# Fetching other Data

setwd("./src")
library(tidyverse)
library(rdbnomics)
library(zoo)

## Fetching data from rdbnomics

unique_countries <- c(
  "AT", "BE", "CY", "DE", "EE",
  "ES", "FI", "FR", "GR", "HR", 
  "HU", "IE", "IT", "LT", "LU",
  "LV", "MT", "NL", "PT", "SI",
  "SK", "MX" #MX = Euro Area Code
  )

df <- data.frame(
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
  
  df <- bind_rows(df, df_temp)
}

# rename EURO AREA
df <- df %>%
  mutate(
    REF_AREA = ifelse(REF_AREA == "MX", "I9", REF_AREA), # I9 = Euro Area
    TIME_PERIOD = as.Date(as.yearqtr(df$TIME_PERIOD, format = "%Y-Q%q"), frac = 0)
  )

# Save the data
write_csv(df, "../data/House_Prices.csv")


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
write_csv(df_owner, "../data/ownership.csv")

    
