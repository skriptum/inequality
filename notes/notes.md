# Notes 1



links 

- [Benjamin Braun DWA](https://benjaminbraun.org/posts/dwa/)
- [ECB Data Website](https://data.ecb.europa.eu/data/datasets/DWA?dataset%5B0%5D=Distributional%20Wealth%20Accounts%20%28DWA%29&filterSequence=dataset&advFilterDataset%5B0%5D=Distributional%20Wealth%20Accounts%20%28DWA%29)
  - [Methodological Note](https://data.ecb.europa.eu/sites/default/files/2024-01/DWA%20Methodological%20note.pdf)
  - [Raw CSV](https://data-api.ecb.europa.eu/service/data/DWA?format=csvdata)
  - [Data Explainer](https://data.ecb.europa.eu/data/datasets/DWA/structure)
- [Bundesbank Report](https://www.bundesbank.de/resource/blob/894880/958edb67dec48f1dbdeccaf0efd36768/mL/2022-07-vermoegensbilanz-data.pdf)
  - [Data](https://www.bundesbank.de/en/statistics/macroeconomic-accounting-systems/balance-sheets/balance-sheets-792982) 
  - [Raw XLSX](https://www.bundesbank.de/resource/blob/921176/8bbb8b4814a600adb06df91185c85990/472B63F073F071307366337C94F8C870/verteilungsbasierte-vermoegensbilanzen-xls-data.xlsx)
- [FT Housing Divergence](https://archive.ph/xr43c)
- [Google Ngram: Wealth Inequality](https://books.google.com/ngrams/graph?content=wealth+inequality%2C&year_start=1950&year_end=2022&corpus=en&smoothing=0) 
- 





**Problem**

- Valuation Effect (given Housing Stock increases in Price)
- Quantitiy / Accumulation Effect (new housing is build)



How to prove:

- price driven change = dominant?
  - homeownership rates stable
  - aggregate housing stock slow growth
- Ownership structure is stable
  - among deciles not much change in asset composition
- correlatin with other wealth components
- pass trough from price to wealth
  - correlation between housing prices and wealth gains

Data Needs

- Housing Price Index 
- Dwelling Stock Growth
- Home Ownership Rates across Deciles



How to show link between housing prices and inequality?

- granger causality
- panel regression





**argumentation**

- Housing Gains = increases among deciles: Descriptive
- due to Valuation Effect: Regression
- effects overall inequality: 
  - descriptive: gini among housing assets up
  - decomposition: effect of all asset classes 

=> housing prices -> inequality effect





### Idea Nr 2.: Differential Effect of Housing Price increases on inequality in Europe

Micro Example: Germany

- detailed analyis of housing price dynamics and wealth inequality
- 
  - lerman or shorrocks decomposition
  - impulse response function with Local Projections
- drivers of inequality
  - business wealth
  - and housing wealth?
- due to asset composition among deciles in germany

European Analysis

- different housing prices trajectories over last years
- different asset compositions among deciles
  - countries with broad ownership (e.g Romania)
  - renter countries (Austria)

= different impacts of price increases among countries

- Method: Panel Regression
  - Decile Effects
  - Macro Controls from Eurostat
