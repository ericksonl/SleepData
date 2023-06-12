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
train_data <- sleep_data[train_index,]

test_index <- setdiff(row.names(sleep_data), train_index)
test_data <- sleep_data[test_index,]

model <- glm(SleepQuality ~., family=binomial(), data=train_data)

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

normalized_FP <- FP / max(FP)
normalized_TP <- TP / max(TP) 

plot(x = normalized_FP, y = normalized_TP, type = 'l', xlim = c(0, 1), 
     ylim = c(0, 1), xlab = "False Positive Rate (FPR)",
     ylab = "True Positive Rate (TPR)")

TP_rate <- TP / (TP + FP)
AUC <- mean(TP_rate[-1000])
cat("AUC: ", AUC, "\n")

#-------------------------
rm(data, model, sleep_data, test_data, train_data, alpha, alpha.range, AUC, 
   delta, file_path, FN, FP, normalized_FP, normalized_TP, num.intervals, phat,
   test_index, TN, TP, TP_rate, train_index)
#-------------------------