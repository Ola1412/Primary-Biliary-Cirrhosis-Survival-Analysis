library(survival)
library(flexsurv)
library(dplyr)
library(tidyr)
library(ggplot2)
library(knitr)

############################
# Load the dataset
############################
data("pbc", package = "survival")

# Inspect the dataset
head(pbc)
str(pbc)
summary(pbc)

############################
# Data preparation
############################
pbc <- pbc %>%
  mutate(event = ifelse(status == 2, 1, 0))

pbc_sub <- pbc %>%
  select(time, event, age, sex, bili, albumin, protime, stage)

missing_table <- sapply(pbc_sub, function(x) sum(is.na(x)))
missing_table

pbc_clean <- pbc_sub %>%
  drop_na()

############################
# Data exploration
############################
n_total <- nrow(pbc_clean)
n_events <- sum(pbc_clean$event == 1)
n_censored <- sum(pbc_clean$event == 0)
total_followup <- sum(pbc_clean$time)
print(n_total)
print(n_events)
print(n_censored)
print(total_followup)



# Basic summary table
summary_table <- data.frame(
  Quantity = c("Sample size", "Number of events", "Number censored", "Total follow-up time"),
  Value = c(n_total, n_events, n_censored, total_followup)
)
print(summary_table)

# Basic statistics of key variables
basic_stats <- pbc_clean %>%
  summarise(
    time_min = min(time), time_mean = mean(time), time_max = max(time),
    age_min = min(age), age_mean = mean(age), age_max = max(age),
    bili_min = min(bili), bili_mean = mean(bili), bili_max = max(bili),
    albumin_min = min(albumin), albumin_mean = mean(albumin), albumin_max = max(albumin),
    protime_min = min(protime), protime_mean = mean(protime), protime_max = max(protime),
    stage_min = min(stage), stage_mean = mean(stage), stage_max = max(stage)
  )


print(basic_stats)
