# Parametric Survival Analysis of Primary Biliary Cirrhosis (PBC)

This repository contains our group project on **parametric survival analysis** using the **Primary Biliary Cirrhosis (PBC)** dataset in R. The main goal of the project is to study survival patterns, fit several parametric survival models, compare them using **Akaike Information Criterion (AIC)**, and interpret the life functions of the selected model.

## Project objective

The project was carried out to:

- explore and clean the PBC dataset
- fit several parametric survival models
- compare the fitted models using AIC
- identify the best-fitting model
- compute and interpret the life functions of the chosen model

## Dataset

We used the **pbc** dataset from the `survival` package in R, which contains survival data for patients with liver disease. In the cleaned analysis dataset, there are **410 patients**, with **156 observed deaths** and **254 censored observations**. The total follow-up time is **787,160 days**. Key variables used in the analysis include:

- `time` — follow-up time in days
- `status` — censoring/event indicator
- `age` — age in years
- `bili` — serum bilirubin
- `albumin` — serum albumin
- `protime` — prothrombin time
- `stage` — disease stage

For the analysis, the event variable was defined as `1` when `status == 2` and `0` otherwise. Rows with missing values in `protime` or `stage` were removed.

## Methods

The project was implemented in **R** using packages such as:

- `survival`
- `flexsurv`
- `dplyr`
- `tidyr`
- `ggplot2`
- `knitr`

The following parametric models were fitted:

- Exponential
- Weibull
- Gamma
- Log-normal
- Log-logistic
- Generalized Gamma

## Main result

After comparing the fitted models using AIC, the **Weibull model** was selected as the best-fitting model, with **AIC = 2974.036**. The Gamma and Exponential models were very close, but the Weibull model had the lowest AIC overall. 

The estimated Weibull parameters were:

- **Shape (k)** = 1.112
- **Scale (λ)** = 4665.520

Since **k > 1**, the hazard increases over time, suggesting that the risk of death rises gradually as the disease progresses.

## Survival probabilities

Estimated survival probabilities from the Weibull model were:

- **1 year (365 days)**: 0.9428
- **2 years (730 days)**: 0.8806
- **3 years (1095 days)**: 0.8190
- **5 years (1825 days)**: 0.7031 

## Repository contents

You can expect this repository to include files such as:

- `group3.SA1.R` — the main R script for data preparation, model fitting, model comparison, and Weibull life function analysis
- `group3_SA1.pdf` — the project report/presentation
- additional outputs or figures, depending on what the group decides to upload

## How to run the project

1. Open R or RStudio
2. Install the required packages if they are not already installed
3. Run the script `group3.SA1.R`
4. Review the fitted models, AIC comparison table, and Weibull life function outputs

