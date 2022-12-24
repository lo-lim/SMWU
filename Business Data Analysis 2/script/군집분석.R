rm(c1001, descr, employ, logit1, logit2, difference, dof, prediction)

library(readr)
HRA <- read_csv("attrition_CA.csv")
summary(HRA) #결측치 없음 
table(is.na(HRA))

str(HRA) #척도 확인 
HRA$accident <- as.factor(HRA$accident)
HRA$promotion <- as.factor(HRA$promotion)
HRA$department<- as.factor(HRA$department)
HRA$salary <- as.factor(HRA$salary)
HRA$left<- as.factor(HRA$left)
str(HRA)  #위에 과정을 통해서 일정 변수들 범주형 척도로 잘 변환됨을 알 수 있음 


#### 계층적 군집분석 ####

### STEP1: 데이터프레임 만들기 ###
#범주형 척도로 측정되고, 범주 개수가 3개 이상인 변수를 더미변수로 변경

library(dplyr)
HRA_hr <- HRA %>% filter(department=="hr") #부서가 hr 값들만 추출 
table(is.na(HRA_hr)) #결측치가 있는지 확인, 없으니 진행

### STEP2: 더미변수 만들고 불필요한 변수 제거 ###
str(HRA_hr)  #Facter형 척도 변수에서 salary 변수의 범주만 3가지(department은 hr만 쓸거라 신경 no)
table(HRA_hr$salary) #범주가 3가지 ---> 더미변수 형태처럼 2가지로 변환해야 함(low와 medium을 이용)
HRA_hr <- HRA_hr %>% mutate(low=ifelse(salary=="low", 1,0), medium=ifelse(salary=="medium", 1, 0))
#--->1과 0으로 표현하는 low, medium 변수 생성 
HRA_hr %>% group_by(low, medium) %>% summarise(count=n()) # 3가지 class의 빈도수를 확인 

HRA_hr$id <- NULL
HRA_hr$department <- NULL
HRA_hr$salary<- NULL
#불필요한 변수들 제거 

### STEP3: 사례간의 거리 구하기 ###
install.packages("cluster")
library(cluster)
distance_hr <- daisy(HRA_hr, metric = "gower")

### STEP4: 계층적 군집분석 실행 ###
HRA_CA_hr <- hclust(distance_hr, method="ward.D2")
plot(HRA_CA_hr, col="red", main="HRA")
#plot 함수 이용해서 덴드로그램 그리기

### STEP5: 최적의 군집개수 구하기 ###
str(HRA_hr)
# NbClust 함수에서 유클리디안 거리를 적용하려면 범주형 척도를 계량형 척도로 변경해야 함
HRA_hr$left <- as.numeric(HRA_hr$left)
HRA_hr$accident <- as.numeric(HRA_hr$accident)
HRA_hr$promotion <- as.numeric(HRA_hr$promotion)
str(HRA_hr)  # 모든 변수가 계량형 척도로 변환됨을 확인 

install.packages("NbClust")
library(NbClust)
set.seed(123)  #괄호 안에 아무 숫자 상관없음 
HRA_hr_NC1 <- NbClust(HRA_hr, distance = "euclidean", min.nc = 5, max.nc = 15, method = "average")
#최적의 군집 개수는 '9'이다 

### STEP6: 최적의 군집개수를 기준으로 군집분석 실행 ###
HRA_hr_HCA <- cutree(HRA_CA_hr, 9) #열벡터 
table(HRA_hr_HCA)
result_hr <- aggregate(HRA_hr, by=list(cluster=HRA_hr_HCA), mean) #9가지의 군집간의 특성들을 보여주는 데이터프레임---> 변수들의 특성들을 보여줌(이탈했는지, 급여는 어떤지, 변수별 어떤 특징인지)

HRA_hr <- HRA_hr %>% mutate(cluster1=HRA_hr_HCA)
#원래의 원본 데이터에서 분류된 군집분석 변수를 추가 
table(HRA_hr$cluster1) # k=9에 맞추어서 각각 몇 개씩 분포되어 있는지 확인 

rm(HRA_CA_hr, HRA, HRA_hr_HCA, HRA_hr_NC1, distance_hr, result_hr)

#### K-평균(비계층적) 군집분석 ####

### STEP1: 데이터 프레임 만들고 결측치 제거 ###
HRA_hr_k <- HRA_hr[2:6] #계량형 척도로 측정된 변수만 추출
table(is.na(HRA_hr_k)) #결측치 없어서 그냥 진행

### STEP2: 변수의 표준화###
HRA_hr_k <- scale(HRA_hr_k)   #측정단위를 맞추기 위해 스케일링 실행 

### STEP3: 최적의 군집개수 구하기 ###
set.seed(124) 
library(NbClust)
HRA_hr_NC2 <- NbClust(HRA_hr_k, distance="euclidean", min.nc = 5, max.nc = 15, method = "kmeans")
#최적의 군집개수는 5  

### STEP4: K-평균 군집분석 실행 ###
set.seed(125)
HRA_hr_KCA <- kmeans(HRA_hr_k, centers = 5, nstart = 25)  #centes=에 위에서 구한 최적의 군집개수 넣기 
HRA_hr_KCA$cluster
HRA_hr_KCA$size

result_hr2 <- aggregate(HRA_hr, by=list(cluster=HRA_hr_KCA$cluster), mean) 
library(dplyr)
HRA_hr <- HRA_hr %>% mutate(cluster2=HRA_hr_KCA$cluster)
table(HRA_hr$cluster2) # k=5에 맞추어서 각각 몇 개씩 분포되어 있는지 확인 

HRA_hr %>% group_by(cluster1, cluster2) %>% summarise(n()) %>% print(n=100) #잘리지 않고 다 나오게 print(n=100)
#계층적 군집과 비계층적 군집을 나눈 것끼리 그룹해서 각각의 빈도수 구하기 