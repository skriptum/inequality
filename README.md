# Inequality and Wealth Distribution

This repository contains the data, code, and documentation for my Bachelor's thesis project analyzing wealth inequality in Europe.

---

## Project Structure

```text
.
├── data/               # All input datasets
│   ├── raw/            # Original files (Excel, CSV)
│   ├── processed/      # Cleaned and structured datasets
│   └── models/         # Model input/output files
├── src/                # Core code base
│   ├── 01_preparation/ # Data cleaning and preparation files
│   ├── 02_analysis/    # Econometric models and simulations
│   ├── 03_reporting/   # Plots, tables, robustness checks
│   └── _archive/       # Deprecated or exploratory code
├── output/             # Exported results
├── docs/               # Methodological references
├── renv/               # R package environment
├── renv.lock           # Reproducible package snapshot
├── README.md           # This file
├── inequality.Rproj    # RStudio project file
```


## Setup Instructions

1. Open inequality.Rproj in RStudio.
2. Run renv::restore() to install the required packages.
3. Execute scripts in src/ in order:
  - 01_preparation/
  - 02_analysis/
  - 03_reporting/

## Dependencies

Managed via renv. See renv.lock for exact package versions.

## Notes

File naming and folder structures follow reproducible research practices.
Outputs are not version-controlled; regenerate using the scripts if needed.