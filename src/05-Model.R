# Regression Model 

#--------------------------------
## Load
library(tidyverse)

setwd("./src")
df <- read_csv("../data/DWA_ECB_simplified.csv")
df_house <- read_csv("../data/House_Prices.csv")
df_gini <- read_csv("../data/gini_indices_simplified.csv")

#--------------------------------
## Clean and Calculation

# Housing Price Change
df_house <- df_house %>%
  group_by(REF_AREA) %>%
  mutate(
    HP_R_Change = ( (HP_R_N - dplyr::lag(HP_R_N)) / dplyr::lag(HP_R_N)),
    HP_R_Change_L1 = dplyr::lag(HP_R_Change, 1),
    HP_R_Change_L2 = dplyr::lag(HP_R_Change, 2),
    HP_R_Change_L3 = dplyr::lag(HP_R_Change, 3),
    HP_R_Change_L4 = dplyr::lag(HP_R_Change, 4)
  )

# share of top 10% of total wealth
df_filter <- df %>%
  filter(
   DWA_GRP %in% c("B50", "D06", "D07", "D08", "D09", "D10"), # only compute from deciles
   UNIT_MEASURE == "EUR_R_POP"   # per capita wealth
  ) %>%
  arrange(DWA_GRP) %>% # sort groups 
  select(REF_AREA, DWA_GRP, TIME_PERIOD, TW_NET) %>% #only select relevant columns
  group_by(TIME_PERIOD) %>%
  pivot_wider( # pivot data to wide format for easy calculation
    names_from = DWA_GRP,
    values_from = TW_NET
  ) %>%
  # shares of all classes
  mutate(
   ALL = B50 + D06 + D07 + D08 + D09 + D10,
   B50_share = B50 / ALL,
   M40_share = (D06+D07+D08+D09) / ALL,
   T10_share = D10 / ALL
  ) %>%
  # changes in shares
  group_by(REF_AREA) %>%
  mutate(
    B50_share_change = (B50_share - dplyr::lag(B50_share)) / dplyr::lag(B50_share),
    M40_share_change = (M40_share - dplyr::lag(M40_share)) / dplyr::lag(M40_share),
    T10_share_change = (T10_share - dplyr::lag(T10_share)) / dplyr::lag(T10_share)
  ) 
   
# plot shares over time
df_filter %>%
  filter(REF_AREA == "I9") %>%
  select(TIME_PERIOD, B50_share, M40_share, T10_share) %>%
  pivot_longer(cols = c(B50_share, M40_share, T10_share), names_to = "Group", values_to = "Share") %>%
  ggplot(aes(x = TIME_PERIOD, y = Share, color = Group)) +
  geom_line()

# Combine dataframes
df_comb <- df_filter %>%
  left_join(df_house, by = c("REF_AREA", "TIME_PERIOD")) 

#--------------------------------
## Model

# Simple Linear regression model for Euro Area
model1 <- lm(
  T10_share_change ~ HP_R_Change,
  data = df_comb %>% filter(REF_AREA == "I9")
)

summary(model1)
# beta 1 = -0.08 *, R2 = 0.07

# Middle 40 share
model2 <- lm(
  M40_share_change ~ HP_R_Change,
  data = df_comb %>% filter(REF_AREA == "I9")
)

summary(model2)
# beta 1 = 0.1 *, R2 = 0.06

model3 <- lm(
  B50_share_change ~ HP_R_Change,
  data = df_comb %>% filter(REF_AREA == "I9")
)
summary(model3)
# beta1= 0.36 ***, R2 = 0.18

#---------------
# Simple LM with Lags
model_lag <- lm(
  T10_share_change ~ HP_R_Change + HP_R_Change_L1,
  data = df_comb %>% filter(REF_AREA == "I9")
)
summary(model_lag)
# R2 does not change at all, adj R2 = worse, no significance

#---------------
# Panel Regression Model
plm_model <- plm::plm(
  T10_share_change ~ HP_R_Change,
  data = df_comb,
  index = c("REF_AREA", "TIME_PERIOD"),
  model = "within"
)
summary(plm_model)
# T10:  beta1 = -0.052 ***, R2 = 0.02
# M40: beta1 = 0.04 ***, R2 = 0.017
# B50: beta1 = 0.38***, R2 = 0.05 

plm_model2 <- plm::plm(
  B50_share_change ~ HP_R_Change,
  data = df_comb,
  index = c("REF_AREA", "TIME_PERIOD"),
  model = "within", effect = "twoways"
)
summary(plm_model2)
# no change in betas, worse adj R2

#---------------
# Separate Regression for each country
df_comb %>%
  group_by(REF_AREA) %>%
  group_split() %>%
  map(~ {
    model <- lm(
      T10_share_change ~ HP_R_Change,
      # M40_share_change ~ HP_R_Change,
      # B50_share_change ~ HP_R_Change,
      data = .
    )
    tibble(
      REF_AREA = unique(.$REF_AREA),
      beta1 = coef(model)[2],
      R2 = summary(model)$r.squared,
      significance = ifelse(summary(model)$coefficients[2, 4] < 0.1, "Significant", "Not Significant")
    )
  }) %>%
  bind_rows() %>%
  print(n=30)

#----------------
# Add home ownership rates
df_ownership <- read_csv("../data/ownership.csv") 

df_ownership <- df_ownership %>%
  filter(
    JAHR == 2021,
    DWA_GRP == "ALL" #for this time, only select overall ownership rate
    ) %>%
  pivot_wider(
    names_from = DWA_GRP,
    values_from = OWNER,
    names_prefix = "owner_"
  ) %>%
  select(REF_AREA, owner_ALL)

# Combine with previous data
df_comb <- df_comb %>%
  left_join(df_ownership, by = "REF_AREA")

# Add ownership rate to panel model
model_ownership <- plm::plm(
  T10_share_change ~ HP_R_Change * owner_ALL,
  data = df_comb,
  index = c("REF_AREA", "TIME_PERIOD"),
  model = "within"
)
summary(model_ownership)
# = model worsens



