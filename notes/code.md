# Coding Notes

## File Explanation

- 01: Clean the DWA Data
- Asset Composition & General Growth 
- Gini: Construction for all Countries & Asset Classes
- Gini: Decomposition
- Gini and Housing Prices
- Synthetic Control Method: Extra Data
- Synthetic Control Method: Model

Plots to produce
- Tenant / Owner Wealth Ratio
- Wealth Composition by Decile
- Growth of Housing Wealth
  - Relative: among the Deciles (quarterly returns)
  - Absolute: combined growth (colored by decile)
- Gini Coefficients of Asset Classes


## explanation of the variables

Assets

```
ADA 	Adjusted debt to asset ratio
F_NNA Adjusted total assets/liabilities (financial and net non-financial)

BW 	  Business wealth (NUB + F51M)
F51M 	Unlisted shares and other equity
NUB 	Non-financial business wealth

F4B 	Loans for house purchasing
F4X 	Loans other than for house purchasing

F2M 	Deposits
F3 	  Debt securities
F511 	Listed shares
F52 	Investment fund shares/units
F62 	Life insurance and annuity entitlements
NUN 	Housing wealth (net)

NWA 	Adjusted wealth (net)
```

Groups

```
_Z  not applicable

B50 Bottom 50% based on net wealth concept
D1 	Decile 1 based on net wealth concept
D10 Decile 10 based on net wealth concept
D2 	Decile 2 based on net wealth concept
D3 	Decile 3 based on net wealth concept
D4 	Decile 4 based on net wealth concept
D5 	Decile 5 based on net wealth concept
D6 	Decile 6 based on net wealth concept
D7 	Decile 7 based on net wealth concept
D8 	Decile 8 based on net wealth concept
D9 	Decile 9 based on net wealth concept

HSO Housing status - Owner/partial owner
HST Housing status - Tenant/Free use

T10 Top 10% based on net wealth concept
T5 	Top 5% based on net wealth concept

WSE Working status - Employee
WSR Working status - Retired
WSS Working status - Self-employed
WSU Working status - Unemployed
WSX Working status-Undefined and other
```