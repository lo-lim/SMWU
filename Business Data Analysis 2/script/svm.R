### STEP1: 데이터프레임 작성 및 전처리 ###
library(dplyr)
library(readr)
cancer <- read_csv("cancer.csv") # 파일불러오기
cancer$diagnosis <- as.factor(cancer$diagnosis) # 종속변수 범주형 척도로 바꾸기 
cancer$id <- NULL #분석에 불필요한 변수 제거 
cancer_svm <- as.data.frame(scale(cancer[-1])) # 종속변수를 제외한 계량형 척도 변수들만 할당해서 스케일링 진행 
cancer_svm$diagnosis <- cancer$diagnosis

### STEP2: 두 개의 데이터셋 구성 ###
set.seed(122)
ind <- sample(2, nrow(cancer_svm), replace = T, prob = c(0.7, 0.3))
ind
cancer_svm_train <- cancer_svm[ind==1,]
cancer_svm_test<- cancer_svm[ind==2,]

table(cancer_svm$diagnosis=="M")/nrow(cancer_svm)
table(cancer_svm_train$diagnosis=="M")/nrow(cancer_svm_train)
table(cancer_svm_test$diagnosis=="M")/nrow(cancer_svm_test)
#만약 비율이 비슷하게 안 나오면 set.seed의 숫자를 변경

### liner kernel trick###
### STEP3: train data를 활용한 학습(훈련)
install.packages("e1071")
library(e1071)
set.seed(333)
linear.svm <- tune.svm(diagnosis~., data = cancer_svm_train, kernel="linear", cost=c( 0.1, 0.25, 0.5, 0.75,1,2,3,4,5,7,10)) 
summary(linear.svm) #cost=0.1, Accuracy=1-0.02564103 =0.974359(train의 정확도)
linear.svm$best.model #sv는 47개

### STEP4: test data를 활용한 성능평가 ###
linear.test <- predict(linear.svm$best.model, newdata = cancer_svm_test)
head(linear.test)
library(caret)
confusionMatrix(linear.test, cancer_svm_test$diagnosis)
# A:0.9724, k:0.9384, sen:0.9915, Sp:0.9365, Pr:0.9669(test의 정확도)
# 과대적합 없이 적절함(위에 train에서 A가 0.9743인데 test데이터에서 A가 0.9724라 큰 차이 없음)
# 차이가 크면 과대적합 의심해 볼 수 있음. 



### polynomial kernel trick###
### STEP3: train data를 활용한 학습(훈련)

set.seed(444)
poly.svm <- tune.svm(diagnosis~., data = cancer_svm_train, kernel="polynomial", degree = c(2:5),
                     gamma = seq(0.5, 3, by=0.5),
                     coef0 = seq(0.5, 3, by=0.5),
                     cost = c(0.1, 0.25, 0.5, 1, 2))
summary(poly.svm)
poly.svm$best.model
# degree:2, gamma:0.5, cost:0.25, sv=54/ Accuracy=1-0.04136302=0.9586

### STEP4: test data를 활용한 성능평가 ###
poly.test <- predict(poly.svm$best.model, newdata = cancer_svm_test)
confusionMatrix(poly.test, cancer_svm_test$diagnosis)
# A:0.9503, k:0.8908, sen:0.9576, Sp:0.9365, Pr:0.9658
# 과대적합 없이 적절함(위에 train에서 A가 0.9586인데 test데이터에서 A가 0.9503라 큰 차이 없음)/ liner kernel trick이 poly kernel trick보다 우수한 성과를 도출함

### rbf kernel trick###
### STEP3: train data를 활용한 학습(훈련)

set.seed(555)
rbf.svm <- tune.svm(diagnosis~., data = cancer_svm_train
                    , kernel="radial", 
                    gamma = seq(0.01, 2, by=0.1),
                    cost = seq(0.01, 2, by=0.1))
summary(rbf.svm)
rbf.svm$best.model
#gamma=0.01, cost=1.11/ Accuracy=1-0.0257085=0.9743, sv=85

### STEP4: test data를 활용한 성능평가 ###
rbf.test <- predict(rbf.svm$best.model, newdata = cancer_svm_test)
confusionMatrix(rbf.test, cancer_svm_test$diagnosis)
# A:0.9558, k:0.89996, sen:1, Sp:0.8730, Pr:0.9365
# 위에 두 가지 kernel trick에 비해서는 약간의 과대적합(train에서는 0.9743인데 0.9558로 약간 떨어져서 약간의 과대적합이 존재할 수도 있음)/ liner kernel trick이 rbf kernel trick보다 우수한 성과를 도출함

### sigmod kernel trick###
### STEP3: train data를 활용한 학습(훈련)

set.seed(666)
sigmoid.svm <- tune.svm(diagnosis~., data = cancer_svm_train
                    , kernel="sigmoid", 
                    gamma = seq(0.01, 2, by=0.1),
                    cost = seq(0.01, 2, by=0.1))
summary(sigmoid.svm)
sigmoid.svm$best.model
#gamma=0.01, cost=1.21/Accuracy=1-0.028542510=0.9715, sv=86  

### STEP4: test data를 활용한 성능평가 ###
sigmoid.test <- predict(sigmoid.svm$best.model, newdata = cancer_svm_test)
confusionMatrix(sigmoid.test, cancer_svm_test$diagnosis)
# A:0.9669, k:0.9253, sen:1, Sp:0.9048, Pr:0.9516
# 원래 A 값이 0.9715과 얼마 차이 안 나서 과대적합 문제는 없음/linear kernel trick이 sigmoid kernel trick보다 우수한 성과를 도출함 

#과대적합인지 아닌지는 각각의 모델에서 train과 test의 a를 비교하고, 성능이 더 우수한 것은 각 모델에서의 confusionMatrix의 a끼리 비교

#4가지 kernel trick 중에서 linear이 가장 우수함


### STEP5: linear kernel trick에 기반한 성능 개선
set.seed(777)
linear.svm <- tune.svm(diagnosis~., data = cancer_svm_train, kernel="linear", cost = seq(0.01, 2, by=0.05)) #cost의 범위를 조절함 
summary(linear.svm) #cost=0.51, Accuracy=1-0.02071525=0.9793/ 약간의 성능 개선(원래는 0.974359)
linear.svm$best.model #sv는 37개

linear.test <- predict(linear.svm$best.model, newdata = cancer_svm_test)
confusionMatrix(linear.test, cancer_svm_test$diagnosis)
# A: 0.9834, K:0.9633, sen:0.9915, sp:0.9683, pr:0.9832
# 원래 linear kernel trick 이용한 성능지표- A:0.9724, k:0.9384, sen:0.9915, Sp:0.9365, Pr:0.9669
# 기존 liner.svm$best model 보다 성능이 개선되었음 

### STEP6: 예측
cancer_pred <- read_csv("cancer_pred.csv")
cancer_pred$id <- NULL
cancer_pred <- as.data.frame(scale(cancer_pred))
svm.predict <- predict(linear.svm$best.model, newdata = cancer_pred)
svm.predict
# svm 예측결과: B  M  B  B  B  M  B  M  B  B 
# knn 예측결과: B  M  B  B  B  M  B  M  B  B
# svm이나 knn 예측결과가 모두 동일함 