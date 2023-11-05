
# This file is the lab for HPM 881 Unit 5 -- Interpretation
# Interpretation of racial categories using 3 different approaches:
# 1) unadjusted
# 2) residual direct effect
# 3) IOM approach
# Created: Dec. 1, 2020
# Read in the data
library(haven)
lab5 <-read_dta( '/workspaces/lecture-5-lab-v2-Shuyi-Song')
# 1. Get to know your data
# Drop observations with <=0 years of education and with missing/invalid responses to RTHLTH53.
data <- subset(data, EDUCYR > 0 & RTHLTH53 > 0)

# Describe the variables of interest
summary(data[c("DVTEXP18", "RACEV1X", "AGELAST", "SEX", "INSCOV", "EDUCYR", "RTHLTH53")])

# Save the cleaned data
saveRDS(data, "lecture5_lab.rds")

# 2. Summarize dental expenditures by race categories in RACEV1X.
# Using dplyr package
library(dplyr)

data %>%
  group_by(RACEV1X) %>%
  summarise(mean_DVTEXP18 = mean(DVTEXP18, na.rm = TRUE))

# 3. Create a bar graph showing the ratio of mean dental expenditures for each race category in RACEV1X relative to White.
# For example, if mean dental expenditures for White people = $150 and mean dental expenditures for Black people = $100,
# the Black/White ratio would = 0.67.

# Using ggplot2 package
library(ggplot2)

data %>%
  group_by(RACEV1X) %>%
  summarise(mean_DVTEXP18 = mean(DVTEXP18, na.rm = TRUE)) %>%
  mutate(dvt_ratio = mean_DVTEXP18 / mean_DVTEXP18[RACEV1X == 1]) %>%
  ggplot(aes(x = factor(RACEV1X), y = dvt_ratio)) +
  geom_bar(stat = "identity") +
  labs(title = "Ratio of Dental Expenditures to White Race") +
  scale_x_discrete(labels = c("White", "Black", "AI/AN", "Asian/NH/PI", "Multiple"))

# 4. Unadjusted means approach: Using t-tests, test for differences in mean dental expenditures between each race category in RACEV1X and White.

# Loop over values of RACEV1X
race_categories <- c(2, 3, 4, 6)

for (i in race_categories) {
  cat("T-test for race category", i, "vs White:\n")
  t_test_result <- t.test(DVTEXP18 ~ factor(RACEV1X), data = data, subset = RACEV1X %in% c(1, i))
  print(t_test_result)
}

# 5. Residual direct effect: Regression DVTEXP18 on RACEV1X, AGELAST, EDUCYR, SEX, INSCOV, and RTHLTH53 using White as the reference category.
# Interpret any statistically significant differences in the RACEV1X categories. Be precise in your language.

# Using lm function
model <- lm(DVTEXP18 ~ factor(RACEV1X) + AGELAST + EDUCYR + factor(SEX) + factor(INSCOV) + RTHLTH53, data = data)
summary(model)

# 6. IOM approach: Which variables would you include in the “Clinical Appropriateness and Need” category?
# Which variables would you include in the “Operation of health care systems and legal and regulatory environment” category?
# NOTE: We do not have measures of patient preferences.

# Clinical appropriateness and need: AGELAST SEX RTHLTH53
# Operation: EDUCYR INSCOV

clinical_vars <- c("AGELAST", "SEX", "RTHLTH53")
operation_vars <- c("EDUCYR", "INSCOV")

# 7. Generate predicted dental expenditures for the average White person.

white_mean <- subset(data, RACEV1X == 1) %>%
  summarise_all(mean, na.rm = TRUE)

white_pred <- predict(model, newdata = white_mean)

# 8. For each other race category in RACEV1X, generate predicted dental expenditures for the average person but use the White
# averages for Clinical Appropriateness and Need variables for every racial group.

predictions <- data %>%
  group_by(RACEV1X) %>%
  mutate_at(vars(clinical_vars), ~ white_mean[[.]]) %>%
  summarise(pred_DVTEXP18 = mean(predict(model, newdata = .), na.rm = TRUE))

# 9. Compare differences in predictions between race categories and White using the IOM approach vs the residual direct effect approach.
# Which approach generates larger disparities? For which racial groups?

# Residual direct effect
coef(model)[2]  # Coefficient for factor(RACEV1X) Black

# IOM approach
diff_iom <- white_mean[["RACEV1X"]] - predictions$pred_DVTEXP18[2]
diff_iom
