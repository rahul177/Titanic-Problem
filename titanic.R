path<-("C:/Users/Rahul Kumar/Downloads")
setwd(path)
train<-read.csv("train.csv",na.strings=c(" ","","NA"))
test<-read.csv("test.csv",na.strings=c(" ","","NA"))
colSums(is.na(train))
colSums(is.na(test))
library(mlr)
imputed_train<-impute(train,classes=list(factor=imputeMode()))
train<-imputed_train$data
imputed_test<-impute(test,classes=list(factor=imputeMode()))
test<-imputed_test$data
library(zoo)
df<-train$Age
train$Age<-na.approx(df)
colSums(is.na(train))
df1<-test$Age
test$Age<-na.approx(df1)
colSums(is.na(test))
library(rpart)
fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
             data=train,method="class",control=rpart.control(minsplit=2, cp=0))
plot(fit)
text(fit)
Prediction <- predict(fit, test, type = "class")
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
write.csv(submit, file = "titanicsolution.csv", row.names = FALSE)