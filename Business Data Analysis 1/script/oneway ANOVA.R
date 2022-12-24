##### 실습예제1 #####

#### STEP1: 가설수립 ####
anova1 <- ttest
library(dplyr)
anova1 %>% group_by(priority) %>% summarise(mean(price, na.rm = T))

### price 이상치 파악 및 제거 ###
library(psych)
descr <- describe(anova1$price)
descr <- descr %>% mutate(UL = mean + 2*sd)
descr <- descr %>% mutate(LL = mean - 2*sd)
table(anova1$price > descr$UL)
anova1_new <- anova1 %>% filter(price <= descr$UL)

### priority 변수에서 새로운 척도 prior 만들기 ###
install.packages("forcats")
library(forcats)
str(anova1_new)
anova1_new <- anova1_new %>% mutate(prior = fct_collapse(priority, "High" = c("Critical", "High")))
anova1_new %>% group_by(prior) %>% summarise(mean(price, na.rm = T))

#### STEP2: 서브 데이터프레임 만들기 ####
anov1_H <- anova1_new %>% filter(prior == "High")
anov1_M <- anova1_new %>% filter(prior == "Medium")
anov1_L <- anova1_new %>% filter(prior == "Low")
anov1_N <- anova1_new %>% filter(prior == "Not Specified")

#### STEP3: 정규성 검토 ####
summary(anov1_H$price)
summary(anov1_M$price)
summary(anov1_L$price)
summary(anov1_N$price)

hist(anov1_H$price, breaks = seq(0, 600, 10))
hist(anov1_M$price, breaks = seq(0, 600, 10))
hist(anov1_L$price, breaks = seq(0, 600, 10))
hist(anov1_N$price, breaks = seq(0, 600, 10))

shapiro.test(anov1_H$price)
shapiro.test(anov1_M$price)
shapiro.test(anov1_L$price)
shapiro.test(anov1_N$price)

#### STEP4: 등분산성 조건 ####
install.packages("car")
library(car)
leveneTest(price~prior, data = anova1_new)

#### STEP5: ANOVA 검정 ####
anova1_result <- aov(price~prior, data = anova1_new)
summary(anova1_result)


##### 실습예제2 #####

#### STEP1: 가설수립 ####
anova2 <- pttest
anova2 %>% group_by(payment) %>% summarise(mean(expense, na.rm = T))
## H0: 세 집단 간에 expense 모평균은 모두 동일하다 ##
## Ha: 적어도 한 집단의 expense 모평균은 다른 집단과 다르다 ##

#### STEP2: 이상치 검토 및 제거 ####
descr <- describe(anova2$expense)
descr <- descr %>% mutate(UL = mean + 2*sd)
descr <- descr %>% mutate(LL = mean - 2*sd)
table(anova2$expense > descr$UL)
anova2_new <- anova2 %>% filter(expense <= descr$UL)
table(is.na(anova2_new$expense))
anova2_new %>% group_by(payment) %>% summarise(mean(expense))
table(is.na(anova2_new$payment))

#### STEP3: 서브 데이터프레임 만들기 ####
anova2_simple <- anova2_new %>% filter(payment == "간편결제")
anova2_account <- anova2_new %>% filter(payment == "계좌이체")
anova2_credit <- anova2_new %>% filter(payment == "신용카드")

#### STEP4: 정규성 검토 ####
summary(anova2_simple$expense)
summary(anova2_account$expense)
summary(anova2_credit$expense)

hist(anova2_simple$expense, breaks = seq(0, 2000, 40))
hist(anova2_account$expense, breaks = seq(0, 2000, 40))
hist(anova2_credit$expense, breaks = seq(0, 2000, 40))

shapiro.test(anova2_simple$expense)
shapiro.test(anova2_account$expense)
shapiro.test(anova2_credit$expense)

#### STEP5: 등분산 조건 ####
leveneTest(expense~payment, data = anova2_new)
## 알파를 0.01로 했으므로 p-value는 유의하지 않고, 등분산 조건 만족함 ##
## 참고로 만약 알파를 기존처럼 0.05로 했다면 p-value는 유의하므로 등분산 조건 만족 못함 -> 이분산 가정 one-way ANOVA를 시행해야 함 ##

#### STEP6: 등분산 조건 만족 전제로 oneway ANOVA 시행 ####
anova2_result <- aov(expense~payment, data = anova2_new)
summary(anova2_result)
## 대립가설 채택되므로 duncan test로 사후 분석 ##

#### STEP7: 사후분석 ####
install.packages("agricolae")
library(agricolae)
duncan.test(anova2_result, "payment", console = T)
## 신용카드 expense 모평균 > 계좌이체 expense 모평균 = 간편결제 expense 모평균 ##

#### 추가작업: alpha를 0.05로 설정하면, 이분산 가정 oneway ANOVA를 해야 함
oneway.test(expense~payment, data = anova2_new) # 등분산가정 oneway ANOVA와 마찬가지로 대립가설 채택 #
install.packages("dunn.test")
library(dunn.test)
dunn.test(anova2_new$expense, anova2_new$payment, method = "bonferroni")
## 해석방법: 계좌이체 모평균 = 간편결제 모평균 / 신용카드 모평균 > 간편결제 모평균 / 신용카드 모평균 > 계좌이체 모평균 ##