rm(HRA_hr, HRA_hr_k, HRA_hr_KCA, HRA_hr_NC2, result_hr2)


### STEP1: 데이터프레임 준비 및 전처리###
library(dplyr)
library(readr)
cancer <- read_csv("cancer.csv")

str(cancer)
summary(cancer) #결측치 없음
table(is.na(cancer)) 
cancer$diagnosis <- as.factor(cancer$diagnosis)   #문자형(종속변수)를 범주형 척도로 변경 
cancer$id <- NULL   # 분석에 필요없은 id 변수 제거 
table(cancer$diagnosis)

cancer_z <- as.data.frame(scale(cancer[2:31])) #2열~31열(계량형척도 변수) 스케일링 실시 
cancer_z$diagnosis <- cancer$diagnosis #cancer_Z 데이터프레임에 diagnosis변수 복붙해서 추가


### STEP2: 두 개의 데이터셋 구성 ###
set.seed(123)
ind <- sample(2, nrow(cancer_z), replace = T, prob = c(0.7,0.3)) # train과 test의 비율을 7:3으로 나눔 
ind #열벡터 형태#

cancer_train <- cancer_z[ind==1, ] 
cancer_test <- cancer_z[ind==2, ] 
#[행,열]
#행의 번호가 ind가 1인 것들을 train에 2인 것들을 추출해서 이를 test으로 할당 

table(cancer_z$diagnosis =="M")/nrow(cancer_z)
table(cancer_train$diagnosis =="M")/nrow(cancer_train)
table(cancer_test$diagnosis =="M")/nrow(cancer_test)
#M의 비율이 비슷해서 다시 구분할 필요가 없음 

###STEP3: 최적의 k값 도출 ###
library(caret)
grid1 <- expand.grid(k=3:10) #근접한 이웃개수 후보군 설정(k 범위를 3~10으로 설정)
control <- trainControl(method ="repeatedcv", number=10, repeats=5) #학습방법 채택 

set.seed(135)
knn.train <- train(diagnosis~.,data=cancer_train, method="knn", trControl=control, tuneGrid=grid1)
# cancer_train으로 최적의 k를 이용해서 훈련시킴 
knn.train #최적의 k는 8이 됨: A&K가 가장 큼 
varImp(knn.train, scale=F)  #독립변수의 중요도 확인 

### STEP4: 성능평가 ###
pred.test <- predict(knn.train, newdata = cancer_test)  #종속변수 예측값 
pred.test
library(caret)
confusionMatrix(pred.test, cancer_test$diagnosis)
# A:0.9663978 & 0.9271068/ A: 0.9756 & Kappa : 0.9467(최적의 k일 때의 값들 vs matrix 일 때의 값들)
#---> 현재 만든 knn 모델이 train 에만 너무 잘 부합하는 과적합의 문제가 발생하지 않고 test과 같이 다른 데이터에도 잘 적용할 수 있음(과대적합은 우려할 필요가 없음)
# 5개의 성과지표(정밀도, 민감도 등등)가 1에 가깝게 높게 나왔기에 knn 머신러닝 모델은 괜찮은 모델이라고 할 수 있음

### STEP5: 성능개선 ###
install.packages('kknn')
library(kknn)
kknn.train <- train.kknn(diagnosis~., data = cancer_train, kmax = 25, distance = 2, kernel = c("rectangular", "triangular", "Epanerchnikov", "biweight", "triweight", "cosine", "inversion", "Gaussian", "rank", "optimal"))
kknn.train #최적의 k는 20, 방법은 triangular 방법
1-0.02716049 #Accuracy=0.9728(기존 0.9664보다 소폭 증가 ) 

kknn.pred.test <- predict(kknn.train, newdata = cancer_test)
kknn.pred.test
confusionMatrix(kknn.pred.test, cancer_test$diagnosis)
#실제 성능비교는 test 데이터 셋으로 해야 하는데, 기존 knn.train과 비교해서 kknn.train 성능은 동일함(0.9756)

### STEP6: 예측###
library(readr)
cancer_pred <- read_csv("cancer_pred.csv")
cancer_pred$id <- NULL #불필요한 변수 제거
cancer_pred <- as.data.frame(scale(cancer_pred)) 

pred.test2 <- predict(knn.train, newdata = cancer_pred)
pred.test3<- predict(kknn.train, newdata = cancer_pred)
pred.test2
pred.test3
# 예측결과는 두 모델 다 동일: B M B B B M B M B B

rm(cancer, cancer_pred, cancer_test, cancer_train, cancer_z, control, grid1, kknn.pred.test, kknn.train, ind,
   pred.test, pred.test2, pred.test3, knn.train)
