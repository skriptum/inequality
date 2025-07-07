# Fetching other Data

#setwd("./src")
library(tidyverse)
library(rdbnomics)
library(zoo)

#------------------------------------------
## House Prices & Stock Prices

unique_countries <- c(
  "AT", "BE", "CY", "DE", "EE",
  "ES", "FI", "FR", "GR", "HR", 
  "HU", "IE", "IT", "LT", "LU",
  "LV", "MT", "NL", "PT", "SI",
  "SK", "MX" #MX = Euro Area Code
  )

df_house <- data.frame(
  REF_AREA = character(),
  TIME_PERIOD = character(),
  HP_R_N = numeric()
)

for (country in unique_countries) {
  df_temp <- rdb(ids = paste0("BIS/WS_SPP/Q.", country, ".R.628")) %>%
    select(
      REF_AREA,
      original_period,
      original_value,
    ) %>%
    filter(
      original_period >= "2000-01-01",
    ) %>%
    reframe(
      REF_AREA = REF_AREA,
      TIME_PERIOD = original_period,
      HP_R_N = as.numeric(original_value) # House Price index, real, Nomralized to 2010=100
    )
  
  df_house <- bind_rows(df_house, df_temp)
}

# rename EURO AREA
df_house <- df_house %>%
  mutate(
    REF_AREA = ifelse(REF_AREA == "MX", "I9", REF_AREA), # I9 = Euro Area
    TIME_PERIOD = as.Date(as.yearqtr(TIME_PERIOD, format = "%Y-Q%q"), frac = 0)
  )

# Stoxx Euro 50 Index
# ECB/FM/Q.U2.EUR.DS.EI.DJES50I.HSTA

df_stoxx <- rdb(ids = "ECB/FM/Q.U2.EUR.DS.EI.DJES50I.HSTA") %>%
  select(
    original_period,
    value,
  ) %>%
  filter(
    original_period >= "2000-01-01",
  ) %>%
  reframe(
    TIME_PERIOD = as.Date(as.yearqtr(original_period, format = "%Y-Q%q"), frac = 0),
    Stock_Price = as.numeric(value) # Stock Price index, real, Nomralized to 2010=100
  )

df_prices <- df_house %>%
  left_join(df_stoxx, by = "TIME_PERIOD") 

# Save the data
write_csv(df_prices, "../data/proc/prices.csv")

#------------------------------------------
## Ownership Rates 
df_owner <- readxl::read_excel("../data/raw/ownership.xlsx")

# Clean the data
df_owner <- df_owner %>%
  pivot_longer(
    cols = -c("Decile", "JAHR"),
    names_to = "REF_AREA",
    values_to = "OWNER"
  ) %>%
  mutate(
    DWA_GRP = Decile # rename
  ) %>%
  select(-Decile) 

# create an average of homeownership across distribution
df_owner <- df_owner %>%
  group_by(JAHR, REF_AREA) %>%
  summarise(
    OWNER = weighted.mean(OWNER, w = c(0.2,0.2,0.2,0.2,0.1,0.1), na.rm = TRUE), # weighted mean
    .groups = "drop"
  ) %>%
  mutate(
    DWA_GRP = "ALL", # create a new group for the average
  ) %>%
  bind_rows(
    df_owner %>%
      group_by(JAHR, REF_AREA, DWA_GRP)
  )
  

# save the data
write_csv(df_owner, "../data/proc/ownership.csv")

#------------------------------------------
## Macro Data

#GDP Growth: Eurostat/NAMQ_10_PC/Q.CLV_I10_HAB.NSA.B1GQ.AT

unique_countries <- c(
  "AT", "BE", "CY", "DE", "EE",
  "ES", "FI", "FR", "EL", "HR", #note: EL = GR
  "HU", "IE", "IT", "LT", "LU",
  "LV", "MT", "NL", "PT", "SI",
  "SK", "EA20" #MX = Euro Area Code
)

df_growth <- data.frame(
  REF_AREA = character(),
  TIME_PERIOD = character(),
  GDP_PC = numeric()
)

for (country in unique_countries) {
  df_temp <- rdb(ids = paste0("Eurostat/NAMQ_10_PC/Q.CLV_I10_HAB.NSA.B1GQ.", country)) %>%
    select(
      geo,
      original_period,
      original_value,
    ) %>%
    filter(
      original_period >= "2000-01-01",
    ) %>%
    reframe(
      REF_AREA = geo,
      TIME_PERIOD = original_period,
      GDP_PC = as.numeric(original_value) # House Price index, real, Nomralized to 2010=100
    )
  
  df_growth <- bind_rows(df_growth, df_temp)
}
# rename EURO AREA and greece
df_growth <- df_growth %>%
  mutate(
    REF_AREA = ifelse(REF_AREA == "EA20", "I9", REF_AREA), # I9 = Euro Area
    REF_AREA = ifelse(REF_AREA == "EL", "GR", REF_AREA), # EL = Greece
    TIME_PERIOD = as.Date(as.yearqtr(df_growth$TIME_PERIOD, format = "%Y-Q%q"), frac = 0)
  )

#save data
write_csv(df_growth, "../data/proc/gdp_growth.csv")





