library(ggplot2)
library(MASS)

file_path <- "C:/Users/Liam/Desktop/Files/Code/GitHubRepos/SleepData/sleepdata.csv"
data <- read.csv(file_path)
sleep_data <- as.data.frame(data)

attach(sleep_data)

summary(sleep_data)

head(sleep_data)
nrow(sleep_data)

set.seed(123)
train_index <- sample(row.names(sleep_data), .65 * nrow(sleep_data))
length(train_index) #Should be 300
train_data <- sleep_data[train_index,]


test_index <- setdiff(row.names(sleep_data), train_index)
length(test_index) #Should be 162
test_data <- sleep_data[test_index,]

model <- lm(SleepQuality ~., data=train_data)
summary(model)
anova(model)

#     Sample mean values of the top five predictors in the data.

cat("Mean Time in Bed (Seconds): ", mean(TimeInBed),
    "\nMean Time Asleep (Seconds): ", mean(TimeAsleep),
    "\nMean Temperature (F): ", mean(Temperature),
    "\nMean Alarm (Y/N): ", mean(Alarm),
    "\nMean Steps: ", mean(Steps),
    "\nMean SleepQuality: ", mean(SleepQuality))

# Conduct a linear regression again this time using only the five significant 
# predictors found in the prior problem. 

model2 <- lm(SleepQuality~ TimeInBed + TimeAsleep + Temperature + Alarm + Steps, sleep_data)

# Summary and ANOVA output
summary(model2)
anova(model2)

#    ---------------------------------------------------------------------------
#     Total sum of square (TSS) of response values
#    ---------------------------------------------------------------------------

TSS <- sum((SleepQuality-mean(SleepQuality))^2)
TSS

#    ---------------------------------------------------------------------------
#     Sum of square error (SSE) and the sum of square regression (SSR).
#    ---------------------------------------------------------------------------

yhat <- predict(model2)

SSR <- sum((yhat-mean(SleepQuality))^2)

SSE <- TSS - SSR

cat("SSR: ", SSR,
    "\nSSE: ", SSE)

#    ---------------------------------------------------------------------------
#     SSR/TSS and SSE/TSS in percent.
#    ---------------------------------------------------------------------------

SSR_percent <- (SSR/TSS) * 100
SSE_percent <- (SSE/TSS) * 100

cat("SSR Percent: ", SSR_percent,
    "\nSSE Percent: ", SSE_percent)

# g) ---------------------------------------------------------------------------
#     Relevant test statistic scores and p-value
#    ---------------------------------------------------------------------------

k <- 5
n <- nrow(sleep_data)
df1 <- k
df2 <- n-k-1

F <- (SSR/df1)/(SSE/df2)
F

pvalue <- 1- pf(F, df1, df2);pvalue

# h) ---------------------------------------------------------------------------
#     Density histogram of the residuals
#    ---------------------------------------------------------------------------


hist(SleepQuality-yhat, probability = TRUE)

# i) ---------------------------------------------------------------------------
#     Predict my average Sleep Quality assuming I am an average person with 
#     respect to the five predictors in the regression model.
#    ---------------------------------------------------------------------------

new_data <- data.frame(TimeInBed = mean(sleep_data$TimeInBed),
                       TimeAsleep = mean(sleep_data$TimeAsleep),
                       Temperature = mean(sleep_data$Temperature),
                       Alarm = mean(sleep_data$Alarm),
                       Steps = mean(sleep_data$Steps))

predicted_sleep_quality <- predict(model2, newdata = new_data)

average_sleep_quality <- predicted_sleep_quality


#-------------------------
rm(data, model, model2, sleep_data, test_data, train_data, df1, df2, F, 
   file_path, k, n, pvalue, SSE, SSE_percent, SSR, SSR_percent, test_index, 
   train_index, TSS, yhat, m1, m2, m3, m4, m5, predicted_values, m_df, new_data, Alarm, Snore)
#-------------------------