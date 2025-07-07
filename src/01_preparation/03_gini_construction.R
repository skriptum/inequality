## 03-Gini-Construction.R

library(tidyverse)

#setwd("./src")
df <- read_csv("../data/proc/dwa_full.csv")
df_filter <- read_csv("../data/proc/dwa_simple.csv")

# Create a Gini coefficient function

calculate_indices <- function(df, country, asset) {

  # create the basic gini table
  df_gini <- df %>%
    filter(
      REF_AREA == country,
      INSTR_ASSET == asset, # housing net wealth
      UNIT_MEASURE == "EUR_R_POP",
      DWA_GRP %in% c("B50", "D06", "D07", "D08", "D09", "D10"),
    ) %>%
    select(DWA_GRP, OBS_VALUE, TIME_PERIOD) %>%
    # add pop shares needed for the calculation
    mutate(
      POP_SHARE = case_when(
        DWA_GRP == "B50" ~ 0.5,
        DWA_GRP == "D06" ~ 0.1,
        DWA_GRP == "D07" ~ 0.1,
        DWA_GRP == "D08" ~ 0.1,
        DWA_GRP == "D09" ~ 0.1,
        DWA_GRP == "D10" ~ 0.1
      )
    ) %>%
    group_by(TIME_PERIOD) %>%
    arrange(TIME_PERIOD, DWA_GRP) %>%
    mutate(
      WEALTH_SHARE = OBS_VALUE / sum(OBS_VALUE),
      CUM_POP_SHARE = cumsum(POP_SHARE),
      CUM_WEALTH_SHARE = cumsum(WEALTH_SHARE)
    )
  
  # calculate Gini and Theil indices
  df_gini <- df_gini %>%
    group_by(TIME_PERIOD) %>%
    summarise(
      #trapezoidal rule for Gini
      GINI = 1 - sum(
        (CUM_POP_SHARE - lag(CUM_POP_SHARE, default = 0)) * 
        (CUM_WEALTH_SHARE + lag(CUM_WEALTH_SHARE, default = 0))),
      THEIL = sum(
        WEALTH_SHARE * log(WEALTH_SHARE / POP_SHARE)
      )
    ) %>%
    mutate(ASSET = asset, REF_AREA = country)
  
  # return the Gini table
  return(df_gini)
}

## for all asset classes
# Calculate Gini indices for all countries and assets
countries <- unique(df$REF_AREA)
assets <- unique(df$INSTR_ASSET)

gini_results <- expand.grid(REF_AREA = countries, ASSET = assets) %>%
  rowwise() %>%
  do(calculate_indices(df, .$REF_AREA, .$ASSET)) %>%
  ungroup()

# Save the results to a CSV file
write_csv(gini_results, "../data/proc/gini_full.csv")

## for simplified asset classes
countries <- unique(df_filter$REF_AREA)
df_filter_wide <- df_filter %>%
  pivot_longer(
    cols = c("BW", "FW", "DEP","HW", "HW_NET", "TW", "DEBT", "TW_NET"),
    names_to = "INSTR_ASSET",
    values_to = "OBS_VALUE"
  )
gini_results_simplified <- expand.grid(REF_AREA = countries, ASSET = unique(df_filter_wide$INSTR_ASSET)) %>%
  rowwise() %>%
  do(calculate_indices(df_filter_wide, .$REF_AREA, .$ASSET)) %>%
  ungroup()

# Save the simplified results to a CSV file
write_csv(gini_results_simplified, "../data/proc/gini_simple.csv")
