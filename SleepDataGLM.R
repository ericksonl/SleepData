library(ggplot2)
library(MASS)

file_path <- "C:/Users/Liam/Desktop/Files/Code/GitHubRepos/SleepData/sleepdataGLM.csv"
data <- read.csv(file_path)
sleep_data <- as.data.frame(data)

attach(sleep_data)

summary(sleep_data)
head(sleep_data)
nrow(sleep_data)

#    ---------------------------------------------------------------------------
#     Create train data to find significant predictors
#    ---------------------------------------------------------------------------

set.seed(123)
train_index <- sample(row.names(sleep_data), .65 * nrow(sleep_data))
length(train_index)
train_data <- sleep_data[train_index,]


test_index <- setdiff(row.names(sleep_data), train_index)
length(test_index)
test_data <- sleep_data[test_index,]

model <- glm(SleepQuality ~., family=binomial(), data=train_data)
summary(model)

phat <- predict(model, test_data, type = 'response')

alpha <- 0.8

### Creation of ROC (Receiver Operating Characteristic) Curve

num.intervals = 1000
delta <- 1/num.intervals
alpha.range <- seq(delta, num.intervals * delta, delta)
TP <- TN <- FN <- FP <- rep(0, length(alpha.range))

for (alpha in alpha.range) {
  TP[alpha * num.intervals] <- sum(test_data$SleepQuality == 1 & phat >= alpha)
  TN[alpha * num.intervals] <- sum(test_data$SleepQuality == 1 & phat < alpha)
  FN[alpha * num.intervals] <- sum(test_data$SleepQuality == 0 & phat <= alpha)
  FP[alpha * num.intervals] <- sum(test_data$SleepQuality == 0 & phat > alpha)
}

(TP + FN) / nrow(test_data) # Correct classification rate
TN / (TN + TP) # Type I error rate
FP / (FN + FP) # Type II error rate

plot(x = FP, y = TP, type='l')

TP_rate <- TP / (TP + FP)
AUC <- mean(TP_rate[-1000])
cat("AUC: ", AUC, "\n")

#-------------------------
rm(data, model, model2, new_data, sleep_data, test_data, train_data, df1, df2, 
   F, file_path, k, n, predicted_sleep_quality, pvalue, SSE, SSE_percent, SSR, 
   SSR_percent, test_index, train_index, TSS, yhat, pred1, pred2, pred3)
#-------------------------