### STEP1: 데이터프레임 준비 및 전처리 ###
library(readr)
churn <- read_csv("churn.csv")
str(churn)
summary(churn)
## 데이터 전처리: NA 처리 ##
mean(churn$age, na.rm = T)
churn$age <- ifelse(is.na(churn$age), 46.505, churn$age)
mean(churn$monthly_charge, na.rm = T)
churn$monthly_charge <- ifelse(is.na(churn$monthly_charge), 65.533, churn$monthly_charge)
table(is.na(churn$age)) #FALSE=7043 ----> 결측치 없음
table(is.na(churn$monthly_charge)) #FALSE=7043 ----> 결측치 없음
churn$noreferral <- ifelse(is.na(churn$noreferral), 0, churn$noreferral)
## class(churn 변수)의 척도 범주형으로 변경 ##
str(churn$churn) #현재 척도 num 
churn$churn <- as.factor(churn$churn)
str(churn$churn) #변경 후 척도 Factor
## churn_z 만들기 ##
churn_z <- as.data.frame(scale(churn[14:25])) 
churn_z$churn <- churn$churn #독립변수를 표준화한 데이터 churn_Z에 종속변수 churn 추가하기 


### STEP2: 두 개의 데이터셋 구성(train/test) ###
set.seed(123) #결과가 달라지지 않도록 함
ind <- sample(2, nrow(churn_z), replace = T, prob = c(0.7,0.3))
ind #열벡터 형태#
churn_train <- churn_z[ind==1, ] #[행,열]
churn_test <- churn_z[ind==2, ] #행의 번호가 ind가 2인 것들을 추출해서 이를 test으로 할당 

table(churn_z$churn==0)/nrow(churn_z)
table(churn_train$churn==0)/nrow(churn_train)
table(churn_test$churn ==0)/nrow(churn_test)
#0(No)의 비율이 0.733~0.738 정도로 비슷해서 다시 구분할 필요가 없음 

###STEP3: 최적의 k값 도출 ###
library(caret)
grid1 <- expand.grid(k=3:30) #근접한 이웃개수 후보군 설정(k가 작아지면 이상치에 영향을 받고, 커지면 큰 딥단으로 분류되는 편향이 심해지니 적절하게 3~30으로 설정)
control <- trainControl(method ="repeatedcv", number=10, repeats=5) #학습방법 채택 
set.seed(135)
knn.train <- train(churn~.,data=churn_train, method="knn", trControl=control, tuneGrid=grid1)
knn.train #최적의 k는 15가 됨: A&K가 가장 큼 
varImp(knn.train, scale=F)  #변수의 중요도 확인 

### STEP4: 성능평가 ###
pred.test <- predict(knn.train, newdata = churn_test)
pred.test
library(caret)
confusionMatrix(pred.test, churn_test$churn)

#A:0.8670736 $ K:0.6290684/ A:0.8696 & K: 0.6296(최적의 k일 때의 값들 vs matrix 일 때의 값들) 

#train모델보다 test모델의 값이 소폭이나마 증가되었기 때문에 현재 만든 knn 모델이 train 에만 너무 잘 부합하는 과적합의 문제가 발생하지 않고 test과 같이 다른데이터 셋에도 잘 적용할 수 있음(과대적합은 우려할 필요가 없음)

#단 Kappa의 값이 너무 낮아 k의 범위를 수정 

## k의 범위 수정 ##
grid2 <- expand.grid(k=3:10) #근접한 이웃개수 후보군 설정(k의 범위를 좁게 수정)
set.seed(135)
knn.train2 <- train(churn~.,data=churn_train, method="knn", trControl=control, tuneGrid=grid2)
knn.train2 #최적의 k는 9가 됨: A&K가 가장 큼 

pred.test2 <- predict(knn.train2, newdata = churn_test)
pred.test
library(caret)
confusionMatrix(pred.test2, churn_test$churn) 
#A:0.8649737 & K:0.6288988/A:0.8686 & K:0.6326(최적의 k일 때의 값들 vs matrix 일 때의 값들) 

## 위에서 도출된 최적의 k값들을 기준으로 범위 재설정## 
#범위를 3~10와 3~30으로 설정했을 때 각각 최적의 k가 9와 15가 나왔기에 범위를 9~15으로 설정함 
grid3 <- expand.grid(k=9:15) #k의 값을 9~15으로 설정 
set.seed(135)
knn.train3 <- train(churn~.,data=churn_train, method="knn", trControl=control, tuneGrid=grid3)
knn.train3
#----> 즉 최종적으로 최적의 k를 15로 설정 
# A:0.8696, K:0.6296, Se:0.9605, Sp:0.6131 

### STEP5: 성능개선 ###
install.packages('kknn')
library(kknn)
set.seed(777)
kknn.train <- train.kknn(churn~., data = churn_train, kmax = 25, distance = 2, kernel = c("rectangular", "triangular", "Epanerchnikov", "biweight", "triweight", "cosine", "inversion", "Gaussian", "rank", "optimal"))
kknn.train #최적의 k는 15, 방법은 rectangular 방법
1-0.129697 #Accuracy=0.870303(기존 0.8670보다 소폭 증가 ) 
kknn.pred.test <- predict(kknn.train, newdata = churn_test)
confusionMatrix(kknn.pred.test, churn_test$churn)
#A:0.871(기존 0.8696보다 성능이 좋아짐)


### STEP6: 예측###
library(readr)
churn_pred <- read_csv("churn_predict.csv")
churn_pred$id <- NULL #불필요한 변수 제거
churn_pred <- as.data.frame(scale(churn_pred))

pred.test2 <- predict(knn.train, newdata = churn_pred)
pred.test3<- predict(kknn.train, newdata = churn_pred)
pred.test2
pred.test3
# 예측결과는 두 모델 다 동일: 0 1 0 0 1 0 0 0 0 0

