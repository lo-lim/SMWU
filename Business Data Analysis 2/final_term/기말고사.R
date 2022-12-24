library(readr)
rm(employ)
final1 <- read_csv('final1.csv')

corr.test(final1[2:7], method = "pearson", alpha = 0.05, use="pairwise.complete.obs") 

final1$left <- as.factor(final1$left)

logit1 <- glm(left~satisfaction+evaluation+projects+hours+years, data = final1, family = binomial())
library(car)
outlierTest(logit1)

library(dplyr)
final1<- final1 %>% filter(id !=1347)
logit1 <- glm(left~satisfaction+evaluation+projects+hours+years, data = final1, family = binomial())
summary(logit1)

library(DescTools)
PseudoR2(logit1, which = c("CoxSnell", "Nagelkerke"))

logit2 <- glm(left~satisfaction+evaluation+projects+hours+years+salary, data = final1, family = binomial())

summary(logit1) #13778
summary(logit2) #13334 
13778-13334

difference <- logit1$deviance-logit2$deviance
dof <- logit1$df.residual-logit2$df.residual
1-pchisq(difference,dof)

summary(logit2)

prediction <- predict(logit2, newdata=final1)
prediction #열벡터 
prediction <- ifelse(prediction<0 ,0, 1) #기존의 prediction 값이 음수면 0으로 양수면 1로 변환
#logit value(Yi(hat)) 를 기준값을 0을 기준으로 0과 1로 예측치로 전환 
head(prediction)

library(caret)
# data(employ$result)이고 reference(predction)가 모두 level이 동일한 범주형 척도여야 함

str(final1$left)
str(prediction)
prediction <- as.factor(prediction)
#----> 둘 다 범주형 척도로 변경 
confusionMatrix(final1$left, prediction)

c1001 <- data.frame(id=15000, satisfaction=0.57, evaluation=0.76, projects=4, hours=234, years=4, accident=0, promotion=0, department='technical', salary='medium') #주의 : 변수명이 employ와 일치해야 함
str(c1001)
str(final1)
# 척도가 동일함 # 다 num으로 동일(c1001에는 result변수가 없으니 무시)

predict(logit2, c1001)

## 문제 2## 
final2 <- read_csv('final2.csv')
final2<- scale(final2) 

set.seed(124) 
library(NbClust)
final2_NC2<- NbClust(final2, distance="euclidean", min.nc = 3, max.nc = 5, method = "kmeans")

set.seed(126)
final2_KCA <- kmeans(final2, centers = 3, nstart = 25) 
final2_KCA$cluster
final2_KCA$size

result_hr2 <- aggregate(final2, by=list(cluster=final2_KCA$cluster), mean) 



library(dplyr)
final2 <- final2 %>% mutate(cluster2=final2_KCA$cluster)




##문제 3##
final34 <- read_csv('final34.csv')
final34$left<- as.factor(final34$left)
final34_z<- as.data.frame(scale(final34[3:7]))
final34_z$left<- final34$left

set.seed(123)
ind <- sample(2, nrow(final34_z), replace = T, prob = c(0.8,0.2))  
ind #열벡터 형태#

final34_train <- final34_z[ind==1, ] 
final34_test <- final34_z[ind==2, ] 

library(caret)
grid1 <- expand.grid(k=5:7) 
control <- trainControl(method ="repeatedcv", number=10, repeats=5) #학습방법 채택 

set.seed(135)
knn.train <- train(left~.,data=final34_train, method="knn", trControl=control, tuneGrid=grid1)
# cancer_train으로 최적의 k를 이용해서 훈련시킴 
knn.train
varImp(knn.train, scale=F)

c1002 <- data.frame(id=15000, satisfaction=0.57, evaluation=0.76, projects=4, hours=234, years=4, accident=0, promotion=0, department='technical', salary='medium')
pred.test <- predict(knn.train, newdata = c1002)
pred.test

## 문제 4##
set.seed(555)
rbf.svm <- tune.svm(left~., data = final34_train
                    , kernel="radial", 
                    gamma = seq(0.1, 1, by=0.1),
                    cost = seq(0.1, 1, by=0.1))
summary(rbf.svm)
rbf.svm$best.model
1- 0.03180791 

final4_predict <- read_csv("final4_predict.csv")
final4_predict <- as.data.frame(scale(final4_predict))
rbf.predict <- predict(rbf.svm$best.model, newdata = final4_predict)
rbf.predict 
