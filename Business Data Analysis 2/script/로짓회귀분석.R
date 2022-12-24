rm(cancer, cancer_pred, cancer_svm, cancer_svm_test, cancer_svm_train)
rm(linear.svm, poly.svm, rbf.svm, sigmoid.svm, ind, linear.test, poly.test, rbf.test, sigmoid.test, svm.predict)

library(readr)
employ <- read_csv('employment.csv')

### EDA ###
summary(employ) #결측치 없음
table(is.na(employ))   #총 7000개의 값들에서 결측치가 없음을 확인 

table(employ$result)
table(employ$intern)
table(employ$ranking)
table(employ$self)
# 일정 변수들의 빈도수 확인하기 

str(employ) # 변수들의 척도 확인 ---> 모든 변수들 숫자형 척도 상태(형태는)

### 데이터 전처리 ###
library(dplyr)
library(psych)

descr <- describe(employ[3:6])  #3~6열만 추출(계량형 변수들만)
descr <- descr %>% mutate(UL=mean+3*sd, LL=mean-3*sd)
# 이상치는 없음(UL보다 크거가 LL보다 작은 값 없음)
# ex) bicycle <- bicycle %>% filter(total<735.055760=UL)

### 문제 1 ###
corr.test(employ[2:6], method = "pearson", alpha = 0.05, use="pairwise.complete.obs") 

#H1:GPA가 높을수록 채용될 가능성(확률)이 높다
#H2:test가 높을수록 채용될 가능성(확률)이 높다
#H3:ranking가 높을수록 채용될 가능성(확률)이 높다
#H4:self가 높을수록 채용될 가능성(확률)이 높다

### 문제 2: 로짓회귀식수립과 이상치 확인 ###
logit1 <- glm(result~GPA+test+ranking+self, data = employ, family = binomial())

library(car)
outlierTest(logit1) #2p-value가 0.012245<0.05(alpha)유의하고(유의한 이상치), id=66인 사례는 이상치로 판정함(양측검정)

### 문제 3: 이상치 제거 후, 로짓회귀식 재수립 및 가설검정 ###
employ <- employ %>% filter(id !=66)
logit1 <- glm(result~GPA+test+ranking+self, data = employ, family = binomial())
summary(logit1)
#b1~b4가 모두 유의한 양수로 추정-> H1~H4 채택 
# null deviance(상수로만 구성된 로짓회귀식의 -2LL: 1362.60) & Residual deviance(logit1의 -2LL: 669.96)

### 문제4: 모형적합도 확인 ### 
install.packages("ResourceSelection")
library(ResourceSelection)
hoslem.test(logit1$y, logit1$fitted.values) 
#y: 실제값, fitted.values는 Yi(hat)을 통해 도출된 확률값. p-value>0.05이므로 모형적합도에 적합함.(유의하지 않아야 함)

install.packages("DescTools")
library(DescTools)
PseudoR2(logit1, which = c("CoxSnell", "Nagelkerke"))
#각각의 값들이 0.05를 넘었기에 어느정도 적절한 모형적합도를 보여줌(유의하지 않아야 함)

### 문제 5: intern 추가에 따른 가설수립과 로짓회귀식 수립###
corr.test(employ[2:7], method = "pearson", alpha = 0.05, use="pairwise.complete.obs")

#H5: intern 경험이 있으면 채용될 가능성(확률)이 높다
logit2 <- glm(result~GPA+test+ranking+self+intern, data = employ, family = binomial())

### 문제 6: 이상치 제거 및 로짓회귀식 재수립
outlierTest(logit2) #2p-value가 0.011967<0.05(alpha)유의하고(유의한 이상치), 도출된 242는(id=243) 이상치로 판정하여 제거 
employ <- employ %>% filter(id !=243)

logit1 <- glm(result~GPA+test+ranking+self, data = employ, family = binomial()) #id=243 제거 후, 재수립 
logit2 <- glm(result~GPA+test+ranking+self+intern, data = employ, family = binomial()) #제거 후, 재수립(intern 추가) 


### 문제 7: intern 추가 타당성 검토 가설검정 ###
summary(logit1) #Residual deviance(-2LL):  663.97 
summary(logit2) #Residual deviance(-2LL):  651.22
difference <- logit1$deviance-logit2$deviance
dof <- logit1$df.residual-logit2$df.residual
1-pchisq(difference,dof) #p-value 값을 구할 때에는 1에서 pchisq함수를 이용한 값을 빼면 됨 
#자유도가 dof인 1이고 카이제곱 값이 difference인 즉 12.75일 때 p-value가 0.000355<0.05 이므로 유의하고 intern을 추가하는 것이 의미 있음(logit2의 설명력이 더 좋음/모형적합도가 더 좋음)
summary(logit2)
#b1~b5 모두 유의한 양수로 추정되었으므로 H1~H5채택 

### 문제 8: 모형 적합도 확인 ###
hoslem.test(logit2$y, logit2$fitted.values) 
#p-value<0.05이므로 모형적합도에 문제가 약간 있음(유의하기 때문에--> 원래는 유의하지 않아야 함.)
PseudoR2(logit2, which = c("CoxSnell", "Nagelkerke"))
#0.05보다 크게 나왔기게 모형적합도가 떨어진다고는 볼 수 없음

### 문제 9: hit ratio 구하기 ###
prediction <- predict(logit2, newdata=employ) #logit value(Yi(hat)) 도출하여 prediction이라는 열백터 생성 
prediction #열벡터 
prediction <- ifelse(prediction<0 ,0, 1) #기존의 prediction 값이 음수면 0으로 양수면 1로 변환
#logit value(Yi(hat)) 를 기준값을 0을 기준으로 0과 1로 예측치로 전환 
head(prediction)

install.packages("caret")
library(caret)
# data(employ$result)이고 reference(predction)가 모두 level이 동일한 범주형 척도여야 함

str(employ$result)
str(prediction)
employ$result <- as.factor(employ$result)
prediction <- as.factor(prediction)
#----> 둘 다 범주형 척도로 변경 
confusionMatrix(employ$result, prediction)
# confusionMatrix(prediction, employ$result)
# Accuracy : 0.8407   --> hit ratio
# 즉 전체 개수에서 0을 0으로, 1을 1로 정확하게 예측한 비율이 0.8407임

### 문제 10: 예측하기 ###
c1001 <- data.frame(id=1001, GPA=3.58, test=110, ranking=3, self=9, intern=1) #주의 : 변수명이 employ와 일치해야 함
str(c1001)
str(employ)
# 척도가 동일함 # 다 num으로 동일(c1001에는 result변수가 없으니 무시)

predict(logit2, c1001) ##logit value(Yi(hat))= -0.250이므로 0(채용안됨)으로 예측 / 음수니까 0으로, 양수면 1로 예측함
