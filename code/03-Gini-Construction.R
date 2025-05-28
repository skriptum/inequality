## 03-Gini-Construction.R

library(tidyverse)

df <- read_csv("../data/DWA_ECB_clean.csv")

# Create a Gini coefficient function

calculate_indices <- function(df, country, asset) {

  # create the basic gini table
  df_gini <- df %>%
    filter(
      REF_AREA == country,
      INSTR_ASSET == asset, # housing net wealth
      UNIT_MEASURE == "EUR",
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
    mutate(ASSET = asset, COUNTRY = country)
  
  # return the Gini table
  return(df_gini)
}

# Calculate Gini indices for all countries and assets
countries <- unique(df$REF_AREA)
assets <- unique(df$INSTR_ASSET)

gini_results <- expand.grid(COUNTRY = countries, ASSET = assets) %>%
  rowwise() %>%
  do(calculate_indices(df, .$COUNTRY, .$ASSET)) %>%
  ungroup()

# Save the results to a CSV file
write_csv(gini_results, "../data/gini_indices.csv")

# Plot the Gini Indices for germany and housing net wealth & overall

gini_results %>%
  filter(
    COUNTRY == "DE",
    ASSET %in% c("NUN", "NWA")
    ) %>%
  ggplot(aes(x = TIME_PERIOD)) +
    geom_line(aes(y = THEIL, color = ASSET)) 
  


