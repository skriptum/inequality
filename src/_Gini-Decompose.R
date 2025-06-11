## 04-Gini-Decompose.R

library(tidyverse)

#setwd("./src")
#df <- read_csv("../data/DWA_ECB_clean.csv")
df_gini <- read_csv("../data/gini_indices_simplified.csv")
df_filter <- read_csv("../data/DWA_ECB_simplified.csv")

df_wide <-  df_filter %>%
  filter(
    REF_AREA == "DE",
    TIME_PERIOD == "2011-01-01",
    UNIT_MEASURE == "EUR_R_POP",
    ) %>%
  arrange(DWA_GRP)

# add weights
df_wide <- df_wide %>%
  mutate(pop_weight = case_when(
    DWA_GRP == "B50" ~ 0.5,
    TRUE ~ 0.1
  ))

#add ranks
df_wide <- df_wide %>%
  mutate(rank = case_when(
    DWA_GRP == "B50" ~ 0.25,
    DWA_GRP == "D06" ~ 0.55,
    DWA_GRP == "D07" ~ 0.65,
    DWA_GRP == "D08" ~ 0.75,
    DWA_GRP == "D09" ~ 0.85,
    DWA_GRP == "D10" ~ 0.95
  ))

# calculate the means of the asset classes
df_wide <- df_wide %>%
  group_by(TIME_PERIOD, REF_AREA) %>%
  mutate(
    BW = weighted.mean(BW, pop_weight, na.rm = TRUE),
    FW = weighted.mean(FW, pop_weight, na.rm = TRUE),
    DEP = weighted.mean(DEP, pop_weight, na.rm = TRUE),
    HW = weighted.mean(HW, pop_weight, na.rm = TRUE),
    HW_NET = weighted.mean(HW_NET, pop_weight, na.rm = TRUE),
    DEBT = weighted.mean(DEBT, pop_weight, na.rm = TRUE),
    TW = weighted.mean(TW, pop_weight, na.rm = TRUE),
    TW_NET = weighted.mean(TW_NET, pop_weight, na.rm = TRUE),
  ) %>%
  select(-c("pop_weight", "DWA_GRP")) %>%
  unique() %>%
  ungroup()

# compute asset shares
df_wide <- df_wide %>%
  group_by(TIME_PERIOD, REF_AREA) %>%
  mutate(
    share_BW = BW / TW,
    share_FW = FW / TW,
    share_DEP = DEP / TW,
    share_HW = HW / TW,
  ) %>%
  ungroup()

# combine with Gini Data 
df_gini <- df_gini %>%
  filter(
    REF_AREA == "DE",
    TIME_PERIOD == "2011-01-01",
  ) %>%
  select(!c(THEIL)) %>%
  pivot_wider(
    names_from = ASSET,
    values_from = GINI,
    names_prefix = "gini_"
  )

df_wide <- df_wide %>%
  left_join(df_gini, by = c("TIME_PERIOD", "REF_AREA"))


