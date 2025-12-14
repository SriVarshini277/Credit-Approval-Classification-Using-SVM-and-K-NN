#loading required libraries
library(kernlab)
library(kknn)

#load data
data <- read.table("credit_card_data-headers.txt", header = TRUE)
#convert data to matrix
data_matrix <- as.matrix(data)

#prints dataset dimension : [row, column]
cat("Dimensions:", dim(data), "\n")

#prints the frequency of 0 and 1 in column A1
print(table(data[,1]))

#prints top few rows
cat("Top few rows:\n")
print(head(data))

#USING SVM

#We are creating a function to test SVM with different C values
test_svm <- function(Cval) {
  
  m <- ksvm(as.matrix(data[,1:10]), as.factor(data[,11]),
            type="C-svc", kernel="vanilladot", C=Cval, scaled=TRUE)
  
  #calculating coefficients
  a  <- colSums(m@xmatrix[[1]] * m@coef[[1]])
  a0 <- -m@b
  
  #calculate prediction & accuracy
  preds <- predict(m, data[,1:10])
  acc   <- sum(preds == data[,11]) / nrow(data)
  
  #checking prediction distribution - how many 0s vs 1s
  tbl <- table(preds)
  
  return(list(model=m, a=a, a0=a0, accuracy=acc, pred_table=tbl))
}

#trying a bunch of C values in order to find a good one
C_vals <- c(0.01, 0.1, 1, 10, 100, 1000)
results <- list()

cat("Testing C values...\n")
for (c in C_vals) {
  res <- test_svm(c)
  results[[as.character(c)]] <- res
  cat(sprintf("C=%g --> acc=%.3f | preds: 0=%d, 1=%d\n",
              c, res$accuracy,
              ifelse("0" %in% names(res$pred_table), res$pred_table["0"], 0),
              ifelse("1" %in% names(res$pred_table), res$pred_table["1"], 0)))
}
cat("\n* SVM ANALYSIS \n")
#find the best C value
bestC <- names(results)[which.max(sapply(results, function(x) x$accuracy))]
bestRes <- results[[bestC]]

cat("\nBest C:", bestC, "with accuracy:", round(bestRes$accuracy,3), "\n")

#equation for best classifier
cat("\n* SVM CLASSIFIER EQN \n")
cat("f(x) = sign(a0 + a1*x1 + a2*x2 + ... + a10*x10)\n\n")
cat("Coefficients:\n")
cat("intercept a0 =", round(bestRes$a0,6), "\n")
for (i in 1:length(bestRes$a)) {
  cat("a", i, "=", round(bestRes$a[i],6), "\n", sep="")
}

cat("\nClassification accuracy on full dataset:", round(bestRes$accuracy*100,1), "%\n")

#---------------------------------------------------------------------------------------
#Using KNN 

cat("\nK-Nearest Neighbor Analysis\n")

# trying different k values to find the best one
knn_test <- function(k) {
  correct <- 0
  preds <- c()
  
  # leave one out - test each point
  for(i in 1:nrow(data)) {
    train_x <- data[-i, 1:10]
    train_y <- data[-i, 11]
    test_x <- data[i, 1:10, drop=FALSE]
    
    #fit KNN model
    model <- kknn(train_y ~ ., 
                  train = data.frame(train_x, train_y), 
                  test = data.frame(test_x), 
                  k = k, scale = TRUE)
    #KNN model: predicts 'train_y' from 'train_x' using k nearest neighbors (k = k), with scaled data.
    
    pred <- round(model$fitted.values)
    preds <- c(preds, pred)
    
    if(pred == data[i, 11]) {
      correct <- correct + 1
    }
  }
  
  accuracy <- correct / nrow(data)
  return(accuracy)
}

#test different k values
k_vals <- c(1, 3, 5, 7, 9, 11, 15, 21, 25)
results <- c()

for(k in k_vals) {
  acc <- knn_test(k)
  results <- c(results, acc)
  cat("k =", k, "accuracy =", round(acc, 3), "\n")
}

#find the best k
best_k <- k_vals[which.max(results)]
best_acc <- max(results)

cat("\nBest k:", best_k, "with accuracy:", round(best_acc, 3), "\n")
cat("K-NN accuracy:", round(best_acc * 100, 1), "%\n")
