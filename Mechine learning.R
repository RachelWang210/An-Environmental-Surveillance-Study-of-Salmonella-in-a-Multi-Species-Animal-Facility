####cross-validation not workiing because the random effect.

####other methods

######random forest
install.packages("rpart")
install.packages('caret')
install.packages('e1071')
install.packages('ranger')
install.packages("naivebayes")

library('ranger')
library('e1071')
library('caret')
library("rpart")
library("naivebayes")


model <- train(factor(Salmonella_Positive) ~Humidity + Temp + as.factor(Season) + as.factor(Facility) + as.factor(Region) +
                 as.factor(Species) + as.factor(Condition) + as.factor(Environment) + as.factor(Sample_Method), data = sam, method = "lda")
##lda for logistic regression
##knn
##sgb
print(model)


model <- train(Salmonella_Positive ~.,
               data = sam,
               method = "ranger", tuneLength = 5,
               trControl = trainControl(
                 method = "cv",
                 number = 10,
                 verboseIter = FALSE))

####comparing classifiers
myFolds <- createFolds(sam$Salmonella_Positive, k = 10)
sapply(myFolds, function(i) {
  table(sam$Salmonella_Positive[i])/length(i)
})
myControl <- trainControl(
  summaryFunction = twoClassSummary,
  classProb = TRUE,
  verboseIter = FALSE,
  savePredictions = TRUE,
  index = myFolds
)
#glm_model <- train(Salmonella_Positive ~ Humidity + Temp + Season + Facility + Region +
#                     Species + Condition + Environment + Sample_Method, sam, metric = "ROC", method = "glmnet",
#                   tuneGrid = expand.grid(alpha = 0:1, lambda = 0:10/10),
#                   trControl = myControl)
rf_model <- train(Salmonella_Positive ~ Humidity + Temp + Season + Facility + Region +
                    Species + Condition + Environment + Sample_Method, sam, metric = "ROC", method = "ranger",
                  tuneLength = 5, trControl = myControl)
knn_model <- train(Salmonella_Positive ~ Humidity + Temp + Season + Facility + Region +
                     Species + Condition + Environment + Sample_Method, sam, metric = "ROC", method = "knn",
                   tuneLength = 8, trControl = myControl)
print(knn_model)
#svm_model <- train(Salmonella_Positive ~ Humidity + Temp + Season + Facility + Region +
#                     Species + Condition + Environment + Sample_Method, sam, metric = "ROC", method = "svmRadial",
#                   tuneLength = 10, trControl = myControl)
nb_model <- train(Salmonella_Positive ~ Humidity + Temp + Season + Facility + Region +
                    Species + Condition + Environment + Sample_Method, sam, metric = "ROC", method = "naive_bayes",
                  trControl = myControl)

model_list <- list(glmnet = glm_model,
                   rf = rf_model,
                   knn = knn_model,
                   svm = svm_model,
                   nb = nb_model)
resamp <- resamples(model_list)