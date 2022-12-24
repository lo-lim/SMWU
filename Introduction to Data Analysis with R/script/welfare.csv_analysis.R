install.packages("foreign")
library(foreign)
library(dplyr)

## 데이터 프레임 만들기 ##
raw_welfare <- read.spss(file = "2015 welfare.sav", to.data.frame = T)
welfare <- raw_welfare

##변수명 바꾸어서 서브 데이터 프레임 만들기##
welfare <- welfare %>% rename(gender = h10_g3, birth = h10_g4, marriage = h10_g10, religion = h10_g11, job = h10_eco9, income = p1002_8aq1, region = h10_reg7)
welfare7 <- welfare %>% select(gender, birth, marriage, religion, job, income, region)

## 성별 변수 전처리 ##
str(welfare7$gender)
summary(welfare7$gender)
table(welfare7$gender)
welfare7$gender <- ifelse(welfare7$gender == 1, "male", "female")
welfare7$gender <- as.factor(welfare7$gender)

## 월급 변수 전처리 ##
summary(welfare7$income)
hist(welfare7$income, breaks = seq(0, 2400, by = 50))
welfare7$income <- ifelse(welfare7$income == 9999, NA, welfare7$income)
head(welfare)

table(welfare7$income == 0)
welfare7$income <- ifelse(welfare7$income == 0, NA, welfare7$income)
table(is.na(welfare7$income))

## 성별에 따른 월급 차이 분석 ##
gender_income <- welfare7 %>% group_by(gender) %>% summarise(mean_income = mean(income, na.rm = T))
library(ggplot2)
ggplot(gender_income, aes(gender, mean_income, fill = mean_income)) + geom_bar(stat = "identity")

## 나이와 월급 관계 ##
str(welfare7$birth)
summary(welfare7$birth)

welfare7 <- welfare7 %>% mutate(age = 2015 - welfare7$birth + 1)
welfare7 <- welfare7 %>% relocate(age, .after = birth)
hist(welfare7$age, breaks = seq(2, 109, by = 1))

age_income <- welfare7 %>% group_by(age) %>% summarise(mean_income = mean(income, na.rm = T))
ggplot(age_income, aes(age, mean_income, fill = mean_income)) + geom_bar(stat = "identity")
welfare7 <- welfare7 %>% mutate(ageg = ifelse(age < 40, "young", ifelse(age < 65, "middle", "old")))
table(welfare7$ageg)
ageg_income <- welfare7 %>% group_by(ageg) %>% summarise(mean_income = mean(income, na.rm = T))
str(ageg_income)
ageg_income$ageg <- factor(ageg_income$ageg, levels = c("young", "middle", "old"))

gender_ageg_income <- welfare7 %>% group_by(gender, ageg) %>% summarise(mean_income = mean(income, na.rm = T))
ggplot(gender_ageg_income, aes(ageg, mean_income, fill = mean_income)) + geom_bar(stat = "identity")


## 직업과 월급 관계 ##
library(dplyr)
library(readxl)

list_job <- read_excel("2015 codebook.xlsx", sheet = 2)
str(welfare7$job)
str(list_job$job)
welfare7 <- left_join(welfare7, list_job, by = "job")
list_job$job <- as.factor(list_job$job)
welfare7 <- welfare7 %>% relocate(title, .after = job)
table(is.na(welfare7$job))
table(welfare7$job)

table(is.na(welfare7$income))
title_income <- welfare7 %>% filter(!is.na(title) & !is.na(income)) %>% group_by(title) %>% summarise(mean_income = mean(income))
title_income %>% arrange(-mean_income) %>% head(5)
title_income %>% arrange(mean_income) %>% head(5)

title_income20 <- title_income %>% arrange(-mean_income) %>% head(20)
library(ggplot2)
ggplot(title_income20, aes(reorder(title, -mean_income), mean_income, fill = mean_income)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size = 7.5, angle = 50))

## 성별과 직업 관계 ##
title_male <- welfare7 %>% filter(!is.na(title) & gender == "male") %>% group_by(title) %>% summarise(count = n()) %>% arrange(-count) %>% head(20)
title_female <- welfare7 %>% filter(!is.na(title) & gender == "female") %>% group_by(title) %>% summarise(count = n()) %>% arrange(-count) %>% head(20)

## 지역과 연령 관계 ##
str(welfare7$region)
welfare7$region <- as.factor(welfare7$region)
table(welfare7$region)
region_list <- data.frame(region = c(1:7), region_name = c("서울", "수도권", "부울경", "대경", "대전충남", "강원충북", "호남제주"))

str(region_list$region)
region_list$region <- as.factor(region_list$region)
welfare7 <- left_join(welfare7, region_list, by = "region")
welfare7 <- welfare7 %>% relocate(region_name, .after = region)

welfare7 %>% group_by(region_name) %>% summarise(mean(age))
table(welfare7$ageg)

welfare7 %>% group_by(region_name, ageg) %>% summarise(count = n()) %>% mutate(total_subset = sum(count)) %>% mutate(rate = count / total_subset) #지역내 방법1#
welfare_7 %>% group_by(region_name, ageg) %>% summarise(count=n()) %>% mutate(rate=count/sum(count)) #지역내 방법2(방법1보다 나음)#
welfare7 %>% group_by(region_name, ageg) %>% summarise(count = n(), rate = count / 16664) %>% print(n = 21)

### 종합복습 ###
#문제1#
library(dplyr)
welfare <- welfare %>% rename(education = h10_g6)
table(welfare$education)

#문제2#
welfare$education <- ifelse(welfare$education == 1, NA, welfare$education)
table(is.na(welfare$education))

#문제3#
welfare7$education <- welfare$education #방법1#
welfare7 <- welfare7 %>% mutate(education = welfare$education) #방법2#

#문제4#
list_education <- data.frame(education = c(2:9), education_name = c("무학", "초졸", "중졸", "고졸", "전문대졸", "대졸", "석사", "박사"))

#문제5#
str(welfare7$education)
str(list_education$education)
welfare7 <- left_join(welfare7, list_education, by = "education")
welfare7$education <- as.factor(welfare7$education)
welfare7$education_name <- as.factor(welfare7$education_name)

#문제6#
welfare7 <- welfare7 %>% filter(!is.na(education)) %>% mutate(edugrade = ifelse(education %in% c(2:4), "low", ifelse(education %in% c(5, 6), "middle", ifelse(education %in% c(7, 8), "high", "very high"))))
table(welfare7$edugrade)
welfare7$edugrade <- as.factor(welfare7$edugrade)

#문제7#
welfare7 %>% group_by(region_name, edugrade) %>% summarise(count = n()) %>% arrange(-count) %>% print(n=100) 

#문제8#
welfare7 %>% group_by(region_name, edugrade) %>% summarise(count = n()) %>% mutate(rate = count / sum(count))
welfare7 %>% group_by(region_name, edugrade) %>% summarise(count = n(), rate = count / 15806) %>% print(n=100)