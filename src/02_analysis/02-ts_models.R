# Time Series Models

library(tidyverse)
library(sandwich)
library(lmtest)
library(dynlm)

df_comb <- read_csv("../data/proc/panel_data.csv")

#--------------------------------
## Model for EU simple

model_dyn <- dynlm(
  d(log(M40_share)) ~ d(log(HP_R_N)) + d(log(Stock_Price)),
  # d(log(T10_share)) ~ d(log(HP_R_N)) + d(log(Stock_Price)) + zoo(YEAR) + zoo(QUARTER),
  data = df_comb %>% filter(REF_AREA == "EU"),
)
model_dyn.summ <- summary(model_dyn)
model_dyn.summ$coefficients <- unclass(coeftest(model_dyn, vcov = NeweyWest))
model_dyn.summ



#---------------
# Separate Regression for each country

# built a seperate list of models for each Class (b50 etc)

B50_models <- list()

for (country in unique(df_comb$REF_AREA)) {
  model <- dynlm(
    d(log(B50_share)) ~ d(log(HP_R_N)) + d(log(Stock_Price)),
    data = df_comb %>% filter(REF_AREA == country),
  )
  B50_models[[country]] <- model
}

M40_models <- list()

for (country in unique(df_comb$REF_AREA)) {
  model <- dynlm(
    d(log(M40_share)) ~ d(log(HP_R_N)) + d(log(Stock_Price)),
    data = df_comb %>% filter(REF_AREA == country),
  )
  M40_models[[country]] <- model
}

T10_models <- list()

for (country in unique(df_comb$REF_AREA)) {
  model <- dynlm(
    d(log(T10_share)) ~ d(log(HP_R_N)) + d(log(Stock_Price)),
    data = df_comb %>% filter(REF_AREA == country),
  )
  T10_models[[country]] <- model
}

# Save the models to a file

saveRDS(B50_models, file = "../data/models/B50_ts_models.RDS")
saveRDS(M40_models, file = "../data/models/M40_ts_models.RDS")
saveRDS(T10_models, file = "../data/models/T10_ts_models.RDS")

  

