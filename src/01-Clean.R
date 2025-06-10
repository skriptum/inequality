## 01-Clean.R

library(tidyverse)
library(zoo)

setwd("./src")
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

# ADA 	Adjusted debt to asset ratio
# F_NNA Adjusted total assets/liabilities (financial and net non-financial)
# 
# BW 	  Business wealth (NUB + F51M)
# F51M 	Unlisted shares and other equity
# NUB 	Non-financial business wealth
# 
# F4B 	Loans for house purchasing
# F4X 	Loans other than for house purchasing
# 
# F2M 	Deposits
# F3 	  Debt securities
# F511 	Listed shares
# F52 	Investment fund shares/units
# F62 	Life insurance and annuity entitlements
# NUN 	Housing wealth (net)
# 
# NWA 	Adjusted wealth (net)

sort(unique(df$DWA_GRP))

# _Z  not applicable
# 
# B50 Bottom 50% based on net wealth concept
# D1 	Decile 1 based on net wealth concept
# D10 Decile 10 based on net wealth concept
# D2 	Decile 2 based on net wealth concept
# D3 	Decile 3 based on net wealth concept
# D4 	Decile 4 based on net wealth concept
# D5 	Decile 5 based on net wealth concept
# D6 	Decile 6 based on net wealth concept
# D7 	Decile 7 based on net wealth concept
# D8 	Decile 8 based on net wealth concept
# D9 	Decile 9 based on net wealth concept
# 
# HSO Housing status - Owner/partial owner
# HST Housing status - Tenant/Free use
# 
# T10 Top 10% based on net wealth concept
# T5 	Top 5% based on net wealth concept
# 
# WSE Working status - Employee
# WSR Working status - Retired
# WSS Working status - Self-employed
# WSU Working status - Unemployed
# WSX Working status-Undefined and other

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


## Save

write_csv(df, "../data/DWA_ECB_clean.csv")

## Generate a clean german data

df_germany <- df %>%
  filter(
    REF_AREA == "DE",
    INSTR_ASSET %in% c("F51M", "NUB", "F62", "F52", "F511", "F3", "NUN", "F2M", "NWA", "F4X", "F4B"),
    DWA_GRP %in% c("B50", "D06", "D07", "D08", "D09", "D10")
    ) %>%
  select(-c(REF_AREA,KEY,TITLE, COMMENT_TS)) %>%
  pivot_wider(
    names_from = INSTR_ASSET,
    values_from = OBS_VALUE
  ) %>%
  mutate(
    BW = NUB + F51M, # business wealth
    FW = F3 + F511 + F52 + F62, # financial wealth
    DEP = F2M, # deposits
    HW = NUN, # housing wealth
    HW_NET = NUN + F4B, # housing net wealth
    TW = BW + FW + HW + DEP,
    DEBT = F4X + F4B, # total debt
    TW_NET = BW + FW + DEP + HW + DEBT, # total wealth net
  ) %>%
  select(
    TIME_PERIOD, DWA_GRP, UNIT_MEASURE,
    BW, FW, DEP, HW, HW_NET, TW, DEBT, TW_NET
  )

write_csv(df_germany, "../data/DWA_DE.csv")
