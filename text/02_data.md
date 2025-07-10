## Data

### Distributional Wealth Accounts

- main dataset: Distributional Wealth accounts
- asset composition of different deciles of the wealth distribution
  - housing wealth, financial wealth, business wealth, debt (mortgage as well as financial)
- macro consistent with the estimates from QSA
- for an introduction @blatnikIntroducingDistributionalWealth2024
- instpried by US @batty22DistributionalFinancial2022



methodology & Limiations

- described by @engelDevelopingReconciledQuarterly2022
- QSA = assumed to be correct
- macro wealth in each country = distributed according to HFCS
- HFCS = every 3-4 years, EUrozone Member Banks (@networkEurosystemHouseholdFinance2013)
- limitation of pure survey datasets:
  - differential nonresponse (richer HH undervalue)
  - differential underreporting problem (richer HH less)
  - described by @vermeulenEstimatingTopTail2016
- overcome by using a pareto estimation
  - wealth distribution follows pareto (e.g @@atkinsonParetoUpperTail2017)
  - HH from rich lists (forbes or @@nesshoeferRanglisteGroesstenVermoegen2024)
  - pareto curved fitted, create synthetic rich unobserved HH
- linear interpolated between HFCS waves and extrapolated after last HFCS wave (2021)
  - no asset compositon changes afterwards
- tested for robustness + consistency with other distributional data

= still: experimental dataset



selection of data for analysis

- limit to 2021: 
  - lasf HFCS wave
  - covid shock
  - exclude extrapolation errors 
- combination of middle 4 deciles (50-90%) to Middle 40%
  - often done in literature (e.g @pikettyInequalityLongRun2014)
  - similiar asset composition (Plot)
  - large BW starts only in top decile 
- full country data
  - including Hungary (not Eurozone, but data reported)
    - more cases = more reliability
  - abbreviated in plots and tables by 2 digit ISO code
  - full table with names and data availability (APPENDIX)
- simplification of data
  - Business Wealth:  
    - Unlisted shares and other equity
    - Non financial business wealth

  - Financial Wealth: 
    - debt securities
    - listed shares
    - investment fund shares
    - life insurance and annuity entitlements

  - debt
    - loans for house purchasing
    - other loans

  - simplify, similar assets combined, as in literature




descriptive statistics

HH Portfolios of wealth groups over Time (Eurozone Average)

- Bottom 50%:
  - little wealth
  - highly leveraged
  - deposits play a large role
  - flat until 2015, increase afterwards
- Middle 40%:
  - housing = main asset
  - less leveraged than the bottom 50
  - stronger growth in observed period
- Top 10%:
  - non Housing wealth plays a larger role
  - Business Wealth + Financial Wealth
  - lowest leverage of all groups
  - fastest growing



Share of Assets owned by wealth groups (small) (Eurozone)

- Housing
- Financial 
- Business
- Deposits
- further in APPENDIX for largest countries



Asset Composition of Deciles (small) (EUROzone)

- B50, D06,...,D10
- similarity of middle class
- further in APPENDIX for largest countries



large role of housing in net wealth

- Map of Europe



### Additional Data

Housing Prices

- Bank for International Settlements (BIS) 
  - Residential Property Prices Dataset
  - Selected PP index, cross country comparability
- real terms, quarterly
- @scatignaResidentialPropertyPrice2014

Plot

- for better visibility, speareted into regions
- diverging housing price dynamics after 2010
- southern Europe = more stagnating countries
- eastern + western = larger growth





Stock Prices

- Euro Stoxx 50
- 50 firms from 11 countries in the Eurozone
  - broad representation
- 60% of market capitalization captured
- Stoxx Europe 600 
  - largest = UK firms
  - not in Eurozone, not included in DWA
- benchmark for european stock performance
- from ECB financial markets data



Ownership Data

- HFCS 2 waves (2014, 2021)
- to compare changes in ownership among the distribution





