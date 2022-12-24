##### Two-way ANOVA 실습 #####

library(dplyr)

#### STEP1: 가설수립 ####
### 사전작업 ###
two_anova <- pttest
table(is.na(two_anova$expense))
two_anova %>% group_by(gender) %>% summarise(mean(expense, na.rm = T))
table(is.na(two_anova$gender))

## H0: 두 독립변수 간에 상호작용효과가 없다 ##
## Ha: 두 독립변수 간에 상호작용효과가 있다 ##

### 이상치 검토 및 제거 ###
library(psych)
descr <- describe(two_anova$expense)
descr <- descr %>% mutate(UL = mean + 3*sd, LL = mean - 3*sd)
table(two_anova$expense > descr$UL)
two_anova_new <- two_anova %>% filter(expense <= descr$UL)

#### STEP2: 서브 데이터프레임 만들기 ####
two_anova_male <- two_anova_new %>% filter(gender == "Male")
two_anova_female <- two_anova_new %>% filter(gender == "Female")

#### STEP3: 정규성 검토 ####
summary(two_anova_male$expense)
summary(two_anova_female$expense)

hist(two_anova_male$expense, breaks = seq(0, 2000, 40))
hist(two_anova_female$expense, breaks = seq(0, 2000, 40))

shapiro.test(two_anova_male$expense)
shapiro.test(two_anova_female$expense)

#### STEP4: 등분산성 검토 ####
library(car)
leveneTest(expense~gender, data = two_anova_new)

#### STEP5: 이분산 가정 one-way ANOVA 시행(Welch test 시행) ####
oneway.test(expense~gender, data = two_anova_new)
two_anova_new %>% group_by(gender) %>% summarise(mean(expense))
## gender에 따라 집단을 두 개로 구분했을 때, 종속변수 expense의 모평균은 차이가 있다. 뮤(female) > 뮤(male) ##

#### STEP7: two-way ANOVA 시행 및 그래프 그리기 ####
two_anova_result <- aov(expense~gender*os, data = two_anova_new)
summary(two_anova_result)
## 대립가설 채택됨 ##
two_anova_new %>% group_by(os) %>% summarise(mean(expense))

install.packages("HH")
library(HH)
table(two_anova_new$gender)
two_anova_new$gender <- factor(two_anova_new$gender, levels = c("Male", "Female")) ## One-way ANOVA에서 표본평균이 작은 순서로 집단을 먼저 출력하도록 함 ##
interaction2wt(expense~gender*os, data = two_anova_new)

#### STEP8: 집단을 네 개로 세분화했을 때 one-way ANOVA ####
### 집단 네 개(MA, Mi, FA, Fi)로 구분하는 변수 만들기 ###
two_anova_new <- two_anova_new %>% mutate(genderos = ifelse(gender == "Male" & os == "Android", "MA", ifelse(gender == "Male" & os == "iOS", "Mi", ifelse(gender == "Female" & os == "Android", "FA", "Fi"))))
table(two_anova_new$genderos)

## H0: 네 개 집단 간에 expense 모평균은 동일하다 ##
## Ha: 적어도 하나의 집단의 expense 모평균은 다른 집단과 다르다 ##

### 서브 데이터프레임 만들기 ###
two_anova_MA <- two_anova_new %>% filter(genderos == "MA")
two_anova_Mi <- two_anova_new %>% filter(genderos == "Mi")
two_anova_FA <- two_anova_new %>% filter(genderos == "FA")
two_anova_Fi <- two_anova_new %>% filter(genderos == "Fi")

### 정규성 검토와 등분산성 검토 ###
shapiro.test(two_anova_MA$expense)
shapiro.test(two_anova_Mi$expense)
shapiro.test(two_anova_FA$expense)
shapiro.test(two_anova_Fi$expense)

leveneTest(expense~genderos, data = two_anova_new)

### 이분산 가정 one-way ANOVA 시행 ###
oneway.test(expense~genderos, data = two_anova_new)
## Ha 채택. 적어도 하나의 집단의 expense 모평균은 다른 집단과 다른데, 어떻게 다른지 사후분석 해야 함 ##

### 사후분석 시행 ###
library(dunn.test)
dunn.test(two_anova_new$expense, two_anova_new$genderos, method = "bonferroni")

## 뮤(FA) < 뮤(Fi): p-value가 0.0006 < 0.025(알파/2) 이고, t값이 -3.723(마이너스)로 나왔으므로 ##
## 뮤(FA) > 뮤(MA), 뮤(FA) > 뮤(Mi), 뮤(Fi) > 뮤(MA), 뮤(Fi) > 뮤(Mi), 뮤(MA) = 뮤(Mi) ##
## 뮤(Fi) > 뮤(FA) > 뮤(MA) = 뮤(Mi) ##