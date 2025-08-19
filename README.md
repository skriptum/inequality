# Inequality and Wealth Distribution

This repository contains the data, code, and documentation for my Bachelor's thesis project analyzing housing prices as a driver of wealth inequality in Europe. The Final Result is available as [a PDF](https://raw.githubusercontent.com/skriptum/inequality/refs/heads/main/text/main.pdf) or [a Website](https://html-preview.github.io/?url=https://github.com/skriptum/inequality/blob/main/text/main.html). 



## Abstract

This project investigates the connection between wealth inequality and housing prices in Europe. It focuses on the short run reactions of wealth distribution to changes in housing prices. It uses the novel experimantel Distributional Wealth Accounts (DWA) from the ECB.



## Project Structure

```text
.
├── data/               
│   ├── raw/            # Original files (Excel, CSV)
│   ├── processed/      # Cleaned and structured datasets
│   └── models/         # Model files
├── src/                
│   ├── 01_preparation/ # Data cleaning and preparation files
│   ├── 02_analysis/    # Econometric models and simulations
│   ├── 03_reporting/   # Plots, tables, robustness checks
│   └── _archive/       
├── output/             # Exported figures / tables
│   ├── appendix/
│   ├── desc/
│   ├── paneltables/
│   ├── simulation/
│   └── ts_tables/
├── text/               # final text files
│   └── notes/          # notes
├── docs/               # Methodological references
├── renv/               # R package environment
├── renv.lock           # Reproducible package snapshot
├── bachelor.bib        # BibLatex Bibliography File
├── README.md             
```



## Setup Instructions

1. Open inequality.Rproj in RStudio.
2. Run renv::restore() to install the required packages.
3. Download the full dataset in csv format from the ECB website ([here](https://data-api.ecb.europa.eu/service/data/DWA?format=csvdata)) and place it in `data/raw/DWA_ECB.csv`
4. Execute scripts in src/ in order:
     - 01_preparation/
     - 02_analysis/
     - 03_reporting/



## Text Production

The PDF / HTML is produced using [quarto](https://quarto.org). 

`main.qmd` contains the relevant YAML options and includes the respective chapters. Figures and tables are drawn automatically from the `output` directory.

To create the result, make sure to have `quarto` , `pandoc` and a version of LaTeX installed. CD into the `text` directory, then run `quarto render main.qmd --to pdf` to produce the final thesis.



## Dependencies

Managed via renv. See renv.lock for exact package versions.

