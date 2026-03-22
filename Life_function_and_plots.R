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

############################
# Create survival object
############################
SurvObj_pbc <- Surv(time = pbc_clean$time, event = pbc_clean$event)

#####################################
# 6. Fit multiple parametric models
####################################
fits <- list(
  Exponential = flexsurvreg(SurvObj_pbc ~ 1, dist = "exp"),
  Weibull = flexsurvreg(SurvObj_pbc ~ 1, dist = "weibull"),
  LogNormal = flexsurvreg(SurvObj_pbc ~ 1, dist = "lnorm"),
  LogLogistic = flexsurvreg(SurvObj_pbc ~ 1, dist = "llogis"),
  Gamma = flexsurvreg(SurvObj_pbc ~ 1, dist = "gamma"),
  GenGamma = flexsurvreg(SurvObj_pbc ~ 1, dist = "gengamma")
)
print(fits)

#################################
# Model comparison using AIC
#################################
aic_values <- sapply(fits, AIC)
loglik_values <- sapply(fits, logLik)

est_values <- sapply(fits, function(model) {
  est <- model$res[, "est"]
  paste(names(est), "=", round(est, 4), collapse = ", ")
})

model_results <- data.frame(
  Model = names(fits),
  Estimates = unname(est_values),
  LogLik = as.numeric(loglik_values),
  AIC = as.numeric(aic_values)
) %>%
  arrange(AIC)

print(model_results)

# Best model
best_model_name <- names(aic_values)[which.min(aic_values)]
best_model <- fits[[best_model_name]]
best_model_name


#############################################################
#  Parameter estimation for the best model (Weibull)
############################################################
print(best_model)

shape_hat <- best_model$res["shape", "est"]
scale_hat <- best_model$res["scale", "est"]

cat("MLE of shape parameter (k):", round(shape_hat, 3), "\n")
cat("MLE of scale parameter(lambda):", round(scale_hat, 2), "\n")

############################
#  Weibull life functions
############################

time_seq <- seq(0, max(pbc_clean$time), by = 10)  #define time points 

S_t <- exp(-(time_seq / scale_hat)^shape_hat)

h_t <- (shape_hat / scale_hat) * (time_seq / scale_hat)^(shape_hat - 1)

f_t <- (shape_hat / scale_hat) * (time_seq / scale_hat)^(shape_hat - 1) *
  exp(-(time_seq / scale_hat)^shape_hat)

F_t <- 1 - S_t

######################################
#  Mean survival time and variance
########################################
mean_T <- scale_hat*gamma(1 + 1/shape_hat)
var_T <- scale_hat^2*(gamma(1 + 2/shape_hat) - (gamma(1 + 1/shape_hat))^2)
sd_T <- sqrt(var_T)

cat("Mean survival time:", round(mean_T, 2), "days\n")
cat("Variance:", round(var_T, 2), "days^2\n")
cat("Standard deviation:", round(sd_T, 2), "days\n")

#####################################
# 2x2 plots of life functions
#####################################
par(mfrow = c(2, 2))

plot(time_seq, S_t, type = "l", col = "blue", lwd = 2,
     xlab = "Time (days)", ylab = "S(t)", main = "Survival Function")

plot(time_seq, h_t, type = "l", col = "red", lwd = 2,
     xlab = "Time (days)", ylab = "h(t)", main = "Hazard Function")

plot(time_seq, f_t, type = "l", col = "green", lwd = 2,
     xlab = "Time (days)", ylab = "f(t)", main = "Density Function")

plot(time_seq, F_t, type = "l", col = "purple", lwd = 2,
     xlab = "Time (days)", ylab = "F(t)", main = "CDF Function")

par(mfrow = c(1, 1))