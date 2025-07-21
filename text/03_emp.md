







## Methodology

Panel Regression 

- different portfolio compositions of groups 
  - Different reactions to valuation changes
  - estimate their reaction to chagnes in asset
  - focusing on house prices and stock prices
- reactions of wealth group shares in total wealth to
  - Housing Prices
  - Stock Prices
- can be interpreted as elasiticity of wealth shares with respect to asset prices





Regression Formula
$$
\Delta \log (\omega_{i,t}^g) = \beta_0 + \beta_1 \Delta \log (p_{i,t}^h) + \beta_2 \Delta \log(p^s_{t}) + \epsilon_t
$$

- $\Delta$ = first difference operator $\Delta x_t = x_t - x_{t-1}$
- $\omega$ = wealth share
- $g$ = wealth group
- $i$ = country
- $t$ = quarter
- $p^h$ = house prices
- $p^s$ = stock prices

added with Time FE (1) and Unit FE (2)
$$
+ \gamma_i + \delta_t
$$
and Season and Year Fixed Effects in (3)

Estimations

- (1)-(3): standard OLS Estimators
  - with SCC standard errors by @driscollConsistentCovarianceMatrix1998
  - to adress potential autocorrelation and heteroskadisticity in error terms
- (4) and (5): Mean Group Estimator by @pesaranPooledMeanGroup1999
  - allow for heterogeneity in coefficients
  - 4 = demeaned mean group estimator (similar to Time FE)
  - 5 = standard mean group estimator
  - no Year + Quarter Effect, same as 5



Time Series Regression

- heterogeneity in reactions
- due to heterogeneity in portfolios across europe
- simple panel regression = averages into the coefficient
- => separate regressions for each country





## Results

```
../output/paneltables/T10.tex
../output/paneltables/M40.tex
../output/paneltables/B50.tex
```

T10

- significant coefficients in all specifications
- Time FE absorb Stock Prices (same for all Countries Stoxx 50)
- OLS Estimators: 
  - 1% increase in HP -> 0.05% decrease in top 10 wealth share
  - 1% increase in Stock prices -> 0.01% increase in top 10 wealth share
  - very low R2, large heterogeneity in coefficients
- Mean Group Estimator
  - similar coefficents
  - 5: 1% HP -> 0.057% decrease in wealth share
  - 1% SP -> 0.014% increase in wealth share
  - R2 = around 0.3
- confirms the results by kuhn
  - top 10% share increases when stock prices rise and decreases when HP rise



M40

- opposite directions
- HP: 0.031 - 0.058
- SP: -0.014 - -0.031
- all models statistical significant
- lower R2 than before



B50

- similar to Middle Class in direction of coefficiens
- stronger Reactions in OLS Estimate
- but loses statisticital significance in Year + Quarter FE and the MGE
- heterogeneity too large to be accounted for in the MGE
  - largest differences in HW in the bottom 50% group
  - fits literature 



Transition

- to investigate: individual time series regressions for countries
- heterogeneity in coefficients



## Time Series Regression



for each country
$$
\Delta \log (\omega_{t}^g) = \beta_0 + \beta_1 \Delta \log (p_{t}^h) + \beta_2 \Delta \log(p^s_{t}) + \epsilon_t
$$

Results


- general direction of panel models confirmed
- large heterogeneity
- visible in coefficient plots 
- ../output/ts_tables/B50_coeff.png

```
../output/ts_tables/T10_coeff.png
```

```
../output/ts_tables/M40_coeff.png
```

```
../output/ts_tables/B50_coeff.png
```

- Averaged coefficients of panel model
  - do not hold everywhere
  - always significant outliers, do not confirm theories
  - effect size = varies considerably
- curious outlier: NL
  - T10: SP and HP = positive effect
  - M40: HP = negative effect, SP = not significant
  - B50: HP+SP = very negative effect
  - dutch housing market = outlier (@boelhouwerHousingMarketNetherlands2020)

= the common direction from Panel Models Confirmed

- but differences in effect size
- 1% HP increase leads to vastly different effects on middle class shares in europe



## Counterfactual Simulation

Counterfactual Simulation

- vastly different coefficients = different reactions of share to same increase in HP
- simulation: what would happen if growth in HW in XX would be distributed like in YY
  - ex: Germany: most of the asset gains = going to T10 and M40
  - counter: Spain: more equal distribution of gains
- Case Example: Germany
  - largest Country in Eurozone, unequal distribution of asset price gains
  - simulate what would happen if HP growth would be distributed like in EU average?
- reaction of share of B50





Overall Wealth Growth in quarter $t$
$$
\Delta H_{}^t = H_{}^{t} - H_{}^{t-1}
$$
Share of HW Growth going to wealth group $i$ in quarter $t$
$$
s_{i}^t = \frac{H_{i}^{t} - H_{i}^{t-1}}{\Delta H_{}^{t}} \\
\text{with} \sum_{i=1}^{n} s_i^t = 1
$$
HW in quarter $t$ for wealth group $i$
$$
H_i^t = H_i^{t-1} + s_i^t \times \Delta H^t
$$
Total Wealth
$$
W_i^t = H_i^t + F_i^t + B_i^t + D_i^t
$$

- F = Financial
- B = Business Wealth
- D = Deposits

**Case Example Germany**

simulate Counterfactual housing Wealth
$$
\hat{H}_{DE,i}^t = \hat{H}_{DE,i}^{t-1} + s_{EU,i}^t \times \Delta H_{DE}^t
$$
Calculate counterfactual Total Wealth
$$
\hat{W}_{DE,i}^t =  \hat{H}_i^t + F_i^t + B_i^t + D_i^t
$$
first quarter: baseline wealth in germany in each wealth group

different from 

- Wealth Dynamics in DE: different distribution of gains
- Wealth Dynamics in EU: different growth of housing wealth in quarter



simple accounting exercise to show

- if HW would have been distributed like in EU
- how the bottom 50% would have profited



Results

```
PLOT: B50 HW LEVEL
```

```
PLOT: B50 TW SHARE
```



- B50 would have captured a much larger share of housing wealth gains
  - which were considerable
  - in a absolute sense
- and improve their position in a relative sense
  - share would have increased from ca 2% to 3.5%
  - still abysmal
- counterfactual for other wealth groups (APPENDIX)
  - M40 almost no reaction
  - T10 lose share



Assumptions

- HW closely follows HP
- HP endogenous (as before)
- no asset switching of wealth groups in reaction to different distributions

