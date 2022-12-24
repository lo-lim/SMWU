library(readr)
library(dplyr)

#### read_csv를 쓸 경우 특수문자 인코딩에 문제 발생 ####
ttest <- read.csv("ttest.csv")

#### 데이터 전처리 ####
### 척도 변경하기 ###
ttest$priority <- as.factor(ttest$priority)
ttest$shipping <- as.factor(ttest$shipping)
ttest$customer <- as.factor(ttest$customer)
ttest$category <- as.factor(ttest$category)
ttest$container <- as.factor(ttest$container)
### 범주형척도 변수 빈도 확인 ###
library(descr)
freq(ttest$priority)
freq(ttest$shipping)
freq(ttest$customer)
freq(ttest$category)
freq(ttest$container)
### 변수 위치 조정: 범주형/수치형/문자형 ###
ttest <- ttest %>% relocate(where(is.factor))
ttest <- ttest %>% relocate(margin, .before = name)
### 이상치 검토 ###
summary(ttest)
library(psych)
descr <- describe(ttest[c(6:10)])
descr <- descr %>% mutate(LL = mean - 2*sd)
descr <- descr %>% mutate(UL = mean + 2*sd)
table(ttest$sales > 8945.98)
table(ttest$price > 670.06)
table(ttest$cost > 47.37)
table(ttest$margin > 0.7837)
### 이상치 제거한 데이터 프레임 생성 ###
ttest_new <- ttest %>% filter(sales <= 8945.98, price <= 670.06, cost <= 47.37, margin <= 0.7837)

##### 등분산 가정 t-검정 #####
#### STEP1: 가설수립 ####


#### STEP2: 집단간 데이터 프레임 만들기 ####
ttest_new %>% group_by(customer) %>% summarise(n(), mean(sales))
ttest_HO <- ttest_new %>% filter(customer == "Home Office")
ttest_CS <- ttest_new %>% filter(customer == "Consumer")

#### STEP3: 정규성 검토 ####
summary(ttest_HO$sales)
hist(ttest_HO$sales, breaks = seq(0, 9000, 50))
summary(ttest_CS$sales)
hist(ttest_CS$sales, breaks = seq(0, 9000, 50))
shapiro.test(ttest_HO$sales)
shapiro.test(ttest_CS$sales)
## 정규성 조건 만족하지 못하므로 대응 필요함: 자연로그로 변환 ##
ttest_HO <- ttest_HO %>% mutate(lnsales = log(sales))
ttest_CS <- ttest_CS %>% mutate(lnsales = log(sales))
hist(ttest_HO$lnsales, breaks = seq(1, 10, 0.1))
hist(ttest_CS$lnsales, breaks = seq(1, 10, 0.1))
shapiro.test(ttest_HO$lnsales)
shapiro.test(ttest_CS$lnsales)

#### STEP4: 등분산성 검토 ####
var.test(ttest_HO$lnsales, ttest_CS$lnsales)
var.test(ttest_HO$sales, ttest_CS$sales)

#### STEP5: t검정(가설검정) ####
t.test(ttest_HO$lnsales, ttest_CS$lnsales, alternative = "two.sided", var.equal = T)
t.test(ttest_HO$sales, ttest_CS$sales, alternative = "two.sided", var.equal = F)

##### 이분산가정 t-검정 #####
#### STEP1: 가설수립 ####
ttest_new %>% group_by(category) %>% summarise(n = n(), mean = mean(sales)) %>% arrange(-mean)

#### STEP2: 집단간 데이터 프레임 만들기 ####
ttest_TN <- ttest_new %>% filter(category == "Technology")
ttest_FN <- ttest_new %>% filter(category == "Furniture")

#### STEP3: 정규성 검토 ####
hist(ttest_TN$sales, breaks = seq(0, 9000, 50))
hist(ttest_FN$sales, breaks = seq(0, 9000, 50))
shapiro.test(ttest_TN$sales)
shapiro.test(ttest_FN$sales)
### 정규성 조건 만족하지 못하므로 대응 필요함 ###
ttest_TN <- ttest_TN %>% mutate(lnsales = log(sales))
ttest_FN <- ttest_FN %>% mutate(lnsales = log(sales))
hist(ttest_TN$lnsales, breaks = seq(0, 10, 0.1))
hist(ttest_FN$lnsales, breaks = seq(0, 10, 0.1))
shapiro.test(ttest_TN$lnsales)
shapiro.test(ttest_FN$lnsales)

### STEP4: 등분산성 검토 ###
var.test(ttest_TN$lnsales, ttest_FN$lnsales)
var.test(ttest_TN$sales, ttest_FN$sales)

### STEP5: t검정(가설검정) ###
t.test(ttest_TN$lnsales, ttest_FN$lnsales, alternative = "two.sided", var.equal = F)
t.test(ttest_TN$sales, ttest_FN$sales, alternative = "two.sided", var.equal = T)