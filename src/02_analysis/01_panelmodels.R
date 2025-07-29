# Regression Model 

#--------------------------------
## Load
library(tidyverse)
library(sandwich)
library(lmtest)
library(plm)

#setwd("./src")
df <- read_csv("../data/proc/dwa_simple.csv")
df_house <- read_csv("../data/proc/prices.csv")

#--------------------------------
## Clean and Calculation

# Housing Price Change
df_house <- df_house %>%
  group_by(REF_AREA) %>%
  mutate(
    #HP_R_Change = ( (HP_R_N - dplyr::lag(HP_R_N)) / dplyr::lag(HP_R_N)),
    #STOCK_Change = ( (Stock_Price - dplyr::lag(Stock_Price)) / dplyr::lag(Stock_Price) )
    HP_R_Change = log(HP_R_N) - log(dplyr::lag(HP_R_N)),
    STOCK_Change = log(Stock_Price) - log(dplyr::lag(Stock_Price))
  )

# share of top 10% of total wealth
df_filter <- df %>%
  filter(
   DWA_GRP %in% c("B50", "D06", "D07", "D08", "D09", "D10"), # only compute from deciles
   UNIT_MEASURE == "EUR"   # per capita wealth
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
    B50_share_change = log(B50_share) - log(dplyr::lag(B50_share)),
    M40_share_change = log(M40_share) - log(dplyr::lag(M40_share)),
    T10_share_change = log(T10_share) - log(dplyr::lag(T10_share))
  ) 
   
# plot shares over time
df_filter %>%
  filter(REF_AREA == "EU") %>%
  select(TIME_PERIOD, B50_share, M40_share, T10_share) %>%
  pivot_longer(cols = c(B50_share, M40_share, T10_share), names_to = "Group", values_to = "Share") %>%
  ggplot(aes(x = TIME_PERIOD, y = Share, color = Group)) +
  geom_line()



# Combine dataframes
df_comb <- df_filter %>%
  left_join(df_house, by = c("REF_AREA", "TIME_PERIOD")) %>%
  filter(TIME_PERIOD < "2022-01-01") %>% #exclude post 2021
  mutate(
    YEAR=lubridate::year(TIME_PERIOD),
    QUARTER = lubridate::quarter(TIME_PERIOD)
  ) 

write_csv(df_comb, "../data/proc/panel_data.csv")

#----------------
## Panel Models

plm_model1 <- plm(
  T10_share_change ~ HP_R_Change + STOCK_Change ,# | factor(QUARTER) + factor(YEAR),
  data = df_comb,
  index = c("REF_AREA", "TIME_PERIOD"),
  model = "within", effect = "individual"
)
summary(plm_model1, vcov=vcovSCC)

pmg_model1 <- pmg(
  T10_share_change ~ HP_R_Change + STOCK_Change | factor(QUARTER) + factor(YEAR),
  data = df_comb,
  index = c("REF_AREA", "TIME_PERIOD"),
  model = "mg"
)
summary(pmg_model1, vcov=vcovSCC)

#----------------
## Run all models for each dependent variable

all_models <- list()

for (dependent in c("B50_share_change", "M40_share_change", "T10_share_change")) {
  
  # Build formula dynamically
  fml_main <- as.formula(paste(dependent, "~ HP_R_Change + STOCK_Change"))
  fml_w_fe <- as.formula(paste(dependent, "~ HP_R_Change + STOCK_Change | factor(QUARTER) + factor(YEAR)"))
  
  # Run models
  plm_model1 <- plm(fml_main, data = df_comb, index = c("REF_AREA", "TIME_PERIOD"),
                    model = "within", effect = "time")
  
  plm_model2 <- plm(fml_main, data = df_comb, index = c("REF_AREA", "TIME_PERIOD"),
                    model = "within", effect = "individual")
  
  plm_model3 <- plm(fml_w_fe, data = df_comb, index = c("REF_AREA", "TIME_PERIOD"),
                    model = "within", effect = "individual")
  
  pmg_model1 <- pmg(fml_main, data = df_comb, index = c("REF_AREA", "TIME_PERIOD"),
                    model = "dmg")
  
  pmg_model2 <- pmg(fml_main, data = df_comb, index = c("REF_AREA", "TIME_PERIOD"),
                    model = "mg")
  
  # Store all models for this dependent variable
  all_models[[dependent]] <- list(
    plm_time_fe    = plm_model1,
    plm_unit_fe    = plm_model2,
    plm_unit_fe_wt = plm_model3,
    pmg_wt         = pmg_model1,
    pmg_plain      = pmg_model2
  )
}
saveRDS(all_models, "../data/models/panelmodels.rds")


## MGE Panels with and without NL

df_NL <- df_comb %>%
  filter(REF_AREA != "NL")

B50_NL <- pmg(
  B50_share_change ~ HP_R_Change + STOCK_Change | factor(QUARTER) + factor(YEAR),
  data = df_NL,
  index = c("REF_AREA", "TIME_PERIOD"),
  model = "mg"
)

M40_NL <- pmg(
  M40_share_change ~ HP_R_Change + STOCK_Change | factor(QUARTER) + factor(YEAR),
  data = df_NL,
  index = c("REF_AREA", "TIME_PERIOD"),
  model = "mg"
)

T10_NL <- pmg(
  T10_share_change ~ HP_R_Change + STOCK_Change | factor(QUARTER) + factor(YEAR),
  data = df_NL,
  index = c("REF_AREA", "TIME_PERIOD"),
  model = "mg"
)

B50_normal <- all_models$B50_share_change$pmg_plain
M40_normal <- all_models$M40_share_change$pmg_plain
T10_normal <- all_models$T10_share_change$pmg_plain

# Save models
saveRDS(list(
  T10_normal = T10_normal,
  T10_NL = T10_NL,
  M40_normal = M40_normal,
  M40_NL = M40_NL,
  B50_normal = B50_normal,
  B50_NL = B50_NL
), "../data/models/panelmodels_nl.rds")
