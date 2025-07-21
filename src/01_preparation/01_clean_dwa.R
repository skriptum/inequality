## 01-Clean.R

library(tidyverse)
library(zoo)

#setwd("./src")
df <- read_csv("../data/raw/DWA_ECB.csv")

## Clean 

df <- df %>%
  select(
    KEY,       # identifier (constructed from the other columns)
    REF_AREA,  #country
    INSTR_ASSET, #type of asset
    DWA_GRP, # either decile, housing status, working, quintile
    UNIT_MEASURE, #percent, euro, gini, ...
    TIME_PERIOD, #quartal
    OBS_VALUE, # the relevant number
    COMMENT_TS, # time series descriptor
    TITLE,
    UNIT_MULT, # [6,3,0] = [10^6, 10^3, 10^0]
  )

## Explain 

sort(unique(df$INSTR_ASSET))
sort(unique(df$DWA_GRP))

## Further Cleaning

df <- df %>%
  mutate(
    DWA_GRP = case_when(
      DWA_GRP == "D1" ~ "D01",
      DWA_GRP == "D2" ~ "D02",
      DWA_GRP == "D3" ~ "D03",
      DWA_GRP == "D4" ~ "D04",
      DWA_GRP == "D5" ~ "D05",
      DWA_GRP == "D6" ~ "D06",
      DWA_GRP == "D7" ~ "D07",
      DWA_GRP == "D8" ~ "D08",
      DWA_GRP == "D9" ~ "D09",
      TRUE ~ DWA_GRP
    )
  )

df$TIME_PERIOD <- as.Date(as.yearqtr(df$TIME_PERIOD, format = "%Y-Q%q"), frac = 0)

## Rename Europe I9 to EU

df <- df %>%
  mutate(
    REF_AREA = case_when(
      REF_AREA == "I9" ~ "EU",
      TRUE ~ REF_AREA
    )
  )

## Save

write_csv(df, "../data/proc/dwa_full.csv")

## Generate a df with simplified variables

df_filter <- df %>%
  filter(
    INSTR_ASSET %in% c("F51M", "NUB", "F62", "F52", "F511", "F3", "NUN", "F2M", "NWA", "F4X", "F4B"),
    DWA_GRP %in% c("B50", "D06", "D07", "D08", "D09", "D10")
  ) %>%
  select(-c(KEY, TITLE, COMMENT_TS)) %>%
  pivot_wider(
    names_from = INSTR_ASSET,
    values_from = OBS_VALUE
  ) %>%
  reframe(
    REF_AREA = REF_AREA,
    TIME_PERIOD = TIME_PERIOD,
    DWA_GRP = DWA_GRP,
    UNIT_MEASURE = UNIT_MEASURE,
    BW = NUB + F51M, # business wealth
    FW = F3 + F511 + F52 + F62, # financial wealth
    FW_NET = FW + F4X, # FW - other debt (assumed to be financial)
    DEP = F2M, # deposits
    HW = NUN, # housing wealth
    HW_NET = NUN + F4B, # housing net wealth
    TW = BW + FW + HW + DEP,
    DEBT = F4X + F4B, # total debt
    TW_NET = BW + FW + DEP + HW + DEBT, # total wealth net
  ) 

# Save the simplified data
write_csv(df_filter, "../data/proc/dwa_simple.csv")
