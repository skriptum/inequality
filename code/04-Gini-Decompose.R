## 04-Gini-Decompose.R

library(tidyverse)

# Load the Gini decomposition function

df <- read_csv("../data/DWA_ECB_clean.csv")
df_gini <- read_csv("../data/gini_indices.csv")

# put it into the right order
df_wide <- df %>%
  filter(
    REF_AREA == "DE",
    UNIT_MEASURE == "EUR",
    TIME_PERIOD == "2011-01-01",
    DWA_GRP %in% c("B50", "D06", "D07", "D08", "D09", "D10"),
    INSTR_ASSET != "F_NNA"
    ) %>%
  select(
    OBS_VALUE, 
    INSTR_ASSET, 
    TIME_PERIOD,
    DWA_GRP,
  ) %>% 
  pivot_wider(
    names_from = INSTR_ASSET,
    values_from = OBS_VALUE
  ) %>%
  arrange(DWA_GRP)

# F Rank
df_wide <- df_wide %>%
  mutate(rank = case_when(
    DWA_GRP == "B50" ~ 0.25,
    DWA_GRP == "D06" ~ 0.55,
    DWA_GRP == "D07" ~ 0.65,
    DWA_GRP == "D08" ~ 0.75,
    DWA_GRP == "D09" ~ 0.85,
    DWA_GRP == "D10" ~ 0.95
  ))

# compute asset shares
df_wide <- df_wide %>%
  mutate(
    F2M_share = F2M / NWA,
    F3_share = F3 / NWA,
    F4B_share = F4B / NWA,
    F4X_share = F4X / NWA,
    F511_share = F511 / NWA,
    F52_share = F52 / NWA,
    F62_share = F62 / NWA,
    NUB_share = NUB / NWA,
    NUN_share = NUN / NWA,
  )

# combine with Gini Data 
df_gini %>%
  filter(
    COUNTRY == "DE",
    TIME_PERIOD == "2011-01-01",
    ASSET != "F_NNA"
  ) 
