## 04-Gini-Decompose.R

library(tidyverse)

# Load the Gini decomposition function

df <- read_csv("../data/DWA_ECB_clean.csv")
df_gini <- read_csv("../data/gini_indices.csv")
df_de <- read_csv("../data/DWA_DE.csv")

# put it into the right order
# df_wide <- df %>%
#   filter(
#     REF_AREA == "DE",
#     UNIT_MEASURE == "EUR_R_POP",
#     TIME_PERIOD == "2011-01-01",
#     DWA_GRP %in% c("B50", "D06", "D07", "D08", "D09", "D10"),
#     INSTR_ASSET != "F_NNA"
#     ) %>%
#   select(
#     OBS_VALUE, 
#     INSTR_ASSET, 
#     TIME_PERIOD,
#     DWA_GRP,
#   ) %>% 
#   pivot_wider(
#     names_from = INSTR_ASSET,
#     values_from = OBS_VALUE
#   ) %>%
#   arrange(DWA_GRP)

df_wide <-  df_de %>%
  filter(
    TIME_PERIOD == "2011-01-01",
    UNIT_MEASURE == "EUR_R_POP",
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

# # compute asset shares
# df_wide <- df_wide %>%
#   mutate(
#     share_F2M = F2M / NWA,
#     share_F3 = F3 / NWA,
#     share_F4B = F4B / NWA,
#     share_F4X = F4X / NWA,
#     share_F511 = F511 / NWA,
#     share_F51M = F51M / NWA,
#     share_F52 = F52 / NWA,
#     share_F62 = F62 / NWA,
#     share_NUB = NUB / NWA,
#     share_NUN = NUN / NWA
#   )

df_wide %>%
  mutate(
    share_BW = BW / TW,
    share_FW = FW / TW,
    share_DEP = DEP / TW,
    share_HW = HW / TW
  )

# combine with Gini Data 
df_gini <- df_gini %>%
  filter(
    COUNTRY == "DE",
    TIME_PERIOD == "2011-01-01",
    ASSET != "F_NNA"
  ) %>%
  select(!c(THEIL, COUNTRY)) %>%
  pivot_wider(
    names_from = ASSET,
    values_from = GINI,
    names_prefix = "gini_"
  )

df_wide <- df_wide %>%
  left_join(df_gini, by = "TIME_PERIOD")

# compute Gini Correlations
df_wide <- df_wide %>%
  group_by(TIME_PERIOD) %>%
  mutate(
    R_F2M  = cov(F2M, rank) / cov(NWA, rank),
    R_F3   = cov(F3, rank) / cov(NWA, rank),
    R_F511 = cov(F511, rank) / cov(NWA, rank),
    R_F51M = cov(F51M, rank) / cov(NWA, rank),
    R_F52  = cov(F52, rank) / cov(NWA, rank),
    R_F62  = cov(F62, rank) / cov(NWA, rank),
    R_NUB  = cov(NUB, rank) / cov(NWA, rank),
    R_NUN  = cov(NUN, rank) / cov(NWA, rank),
    R_F4B  = cov(F4B, rank) / cov(NWA, rank),
    R_F4X  = cov(F4X, rank) / cov(NWA, rank),
  )

# now lerman contribution
df_decomp <- df_wide %>%
  group_by(TIME_PERIOD) %>%
  reframe(
    contrib_F2M = mean(share_F2M) * gini_F2M * mean(R_F2M),
    contrib_F3 = mean(share_F3) * gini_F3 * mean(R_F3),
    contrib_F511 = mean(share_F511) * gini_F511 * mean(R_F511),
    contrib_F51M = mean(share_F51M) * gini_F51M * mean(R_F51M),
    contrib_F52 = mean(share_F52) * gini_F52 * mean(R_F52),
    contrib_F62 = mean(share_F62) * gini_F62 * mean(R_F62),
    contrib_NUB = mean(share_NUB) * gini_NUB * mean(R_NUB),
    contrib_NUN = mean(share_NUN) * gini_NUN * mean(R_NUN),
    contrib_F4B = mean(share_F4B) * gini_F4B * mean(R_F4B),
    contrib_F4X = mean(share_F4X) * gini_F4X * mean(R_F4X),
    gini_total = gini_NWA
  ) %>%
  mutate(
    contrib_sum = contrib_F2M + contrib_F3 + contrib_F511 + contrib_F51M + contrib_F52 +
      contrib_F62 + contrib_NUB + contrib_NUN + contrib_F4B + contrib_F4X
  )



