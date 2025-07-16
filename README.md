# Inequality and Wealth Distribution

This repository contains the data, code, and documentation for my Bachelor's thesis project analyzing wealth inequality in Europe.

---

## Overview

This project investigates the connection between wealth inequality and housing prices in Europe. It focuses on the short run reactions of wealth distribution to changes in housing prices, following a similar approach by Kuhn et al. ([2023](https://www.journals.uchicago.edu/doi/abs/10.1086/708815)) for the US. It uses the novel experimantel Distributional Wealth Accounts (DWA) from the ECB.

---

## Project Structure

```text
.
├── data/               
│   ├── raw/            # Original files (Excel, CSV)
│   ├── processed/      # Cleaned and structured datasets
│   └── models/         # Model input/output files
├── src/                
│   ├── 01_preparation/ # Data cleaning and preparation files
│   ├── 02_analysis/    # Econometric models and simulations
│   ├── 03_reporting/   # Plots, tables, robustness checks
│   └── _archive/       
├── output/             # Exported results
│   ├── appendix/
│   ├── desc/
│   ├── paneltables/
│   ├── simulation/
│   └── ts_tables/
├── text/               # final text files
├── docs/               # Methodological references
├── renv/               # R package environment
├── renv.lock           # Reproducible package snapshot
├── README.md           
├── inequality.Rproj    
```


## Setup Instructions

1. Open inequality.Rproj in RStudio.
2. Run renv::restore() to install the required packages.
3. Download the full dataset in csv format from the ECB website ([here](https://data-api.ecb.europa.eu/service/data/DWA?format=csvdata))
4. Execute scripts in src/ in order:

     - 01_preparation/

     - 02_analysis/

     - 03_reporting/

## Dependencies

Managed via renv. See renv.lock for exact package versions.

