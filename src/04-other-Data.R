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
      original_period >= "2010-01-01",
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

#quick plot
df %>%
  filter(
    REF_AREA %in% c("I9", "DE", "ES", "FR", "IT", "NL", "PT", "BE"), # Euro Area and selected countries
    TIME_PERIOD >= "2010-01-01"
  ) %>%
  ggplot(aes(x = TIME_PERIOD, y = HP_R_N, color = REF_AREA)) +
  geom_line()


## Ownership Rates 
