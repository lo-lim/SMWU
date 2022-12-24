library(readr)
library(dplyr)

#### 모비율 비교하기 ####
### 데이터 불러오기 ###
proptest <- read_csv("proptest.csv")

### 빈도수 기준 교차표 만들기 ###
table(proptest$customer == 20 & proptest$trans == "Yes") # 48명 #
table(proptest$customer == 20 & proptest$trans == "No") # 49명 #
table(proptest$customer == 30 & proptest$trans == "Yes") # 30명 #
table(proptest$customer == 30 & proptest$trans == "No") # 73명 #

prop <- matrix(c(48, 49, 30, 73), nrow = 2, ncol = 2, byrow = T)
rownames(prop) <- c(20, 30)
colnames(prop) <- c("Yes", "No")

### 비율 기준 교차표 만들기 ###
prop.table(prop, margin = 1)

### 가설검정 ###
p20_bar - p30_bar가 정규분포를 그리기 위한 조건
97*0.495
97*0.505
103*0.291
103*0.709

prop.test(prop, alternative = "two.sided", correct = T)
p20 > p30(대립가설 채택)
prop.test(prop, alternative = "two.sided", correct = F)


#### 다항 모집단 적합성 검정 ####
telecom <- read_csv("telecom.csv")
table(telecom$past)
table(telecom$current)

### 첫 번째 가설검정; 과거 시점에 3사의 시장점유율이 동일한지 여부 ###
chisq.test(c(120, 100, 80)) # 대립가설 채택 #

### 두 번째 가설검정; 현재 시점에 3사의 시장점유율이 동일한지 여부 ###
chisq.test(c(149, 85, 66)) # 대립가설 채택 #

### 세 번째 가설검정; 과거 시장점유율과 현재 시장점유율이 모두 동일한지 여부 ###
chisq.test(c(149, 85, 66), p = c(0.4, 1/3, 4/15)) # 대립가설 채택 #

### 세 번째 가설검정에 대하 사후분석 ###
prop_SKT <- matrix(c(120, 180, 149, 151), nrow = 2, ncol = 2, byrow = T)
rownames(prop_SKT) <- c("past", "current")
colnames(prop_SKT) <- c("SKT", "Not SKT")
prop_SKT
prop.test(prop_SKT, alternative = "two.sided", correct = T)
## SKT의 시장점유율은 과거와 현재 비교시 변화 있음(높아짐) ##

prop_KT <- matrix(c(100, 200, 85, 215), nrow = 2, ncol = 2, byrow = T)
rownames(prop_KT) <- c("past", "current")
colnames(prop_KT) <- c("KT", "Not KT")
prop_KT
prop.test(prop_KT, alternative = "two.sided", correct = T)
## KT의 시장점유율은 과거와 현재 비교시 변화 없음 ##

prop_LGU <- matrix(c(80, 220, 66, 234), nrow = 2, ncol = 2, byrow = T)
rownames(prop_LGU) <- c("past", "current")
colnames(prop_LGU) <- c("LGU", "Not LGU")
prop_LGU
prop.test(prop_LGU, alternative = "two.sided", correct = T)
## LGU+의 시장점유율은 과거와 현재 비교시 변화 없음 ##


#### 독립성 검정 ####
tennis <- read_csv("tennis.csv")
str(tennis)

### 데이터 전처리 ###
names(tennis) <- tolower(names(tennis))
tennis$surface <- tolower(tennis$surface)
tennis$result <- tolower(tennis$result)
tennis$surface <- as.factor(tennis$surface)

table(is.na(tennis$surface))
table(tennis$surface)
library(forcats)
tennis$surface <- fct_collapse(tennis$surface, "clay" = c("clay", "clay (i)"))
tennis$surface <- fct_collapse(tennis$surface, "hard" = c("hard", "hard (i)"))
tennis_new <- tennis %>% filter(!is.na(surface))

table(tennis_new$player)
tennis_Nadal <- tennis_new %>% filter(player == "Rafael Nadal")
table(tennis_Nadal$result)
tennis_Nadal$result <- fct_collapse(tennis_Nadal$result, "l" = c("l", "lr", "lw"))
tennis_Nadal$result <- fct_collapse(tennis_Nadal$result, "w" = c("w", "wr", "ww"))

xtabs(~surface + result, tennis_Nadal)
prop.table(xtabs(~surface + result, tennis_Nadal), margin = 1)
chisq.test(xtabs(~surface + result, tennis_Nadal))
## suface와 result는 독립적이지 않음. surface가 results에 영향을 미침: clay court에서 승률이 더 높다. ##