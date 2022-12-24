### filter 함수 실습 ###
library(dplyr)
exam %>% filter(class == 1)

exam_male <- exam %>% filter(gender == "Male")
var(exam_male$english)

##문제1~3##
exam_123 <- exam %>% filter(class %in% c(1, 2, 3))
mean(exam_123$math)
exam_N4 <- exam %>% filter(class != 4) %>% filter(math >= 90 | history >= 95)
exam %>% filter(english >= quantile(english, probs = c(0.9)))
quantile(exam$english, probs = c(0.9))

##문제4~6##
mpg_d4 <- mpg %>% filter(displ <= 4)
mpg_d5 <- mpg %>% filter(displ >= 5)
mean(mpg_d4$highway)
mean(mpg_d5$highway)

mpg_audi <- mpg %>% filter(manufacturer == "audi")
mpg_toyota <- mpg %>% filter(manufacturer == "toyota")
mean(mpg_audi$city)
mean(mpg_toyota$city)

mpg_CFH <- mpg %>% filter(manufacturer %in% c("chevrolet", "ford", "honda"))
mean(mpg_CFH$highway)


### select 함수 실습 ###
exam %>% select(class, math, english)
exam %>% select(-address)
exam %>% select(contains("add"))

##문제7~9##
exam %>% filter(class == 1) %>% select(gender, math)
mpg_cc <- mpg %>% select(class, city)
mpg_cc_suv <- mpg_cc %>% filter(class == "suv")
mean(mpg_cc_suv$city)
mpg_cc_compact <- mpg_cc %>% filter(class == "compact")
mean(mpg_cc_compact$city)
mean((mpg_cc %>% filter(class == "suv"))$city) #9번 문제 다른 방식 풀이#
mean((mpg_cc %>% filter(class == "compact"))$city) #9번 문제 다른 방식 풀이#

### arrange 함수 실습 ###
exam %>% arrange(math)
exam %>% arrange(-math)
exam %>% arrange(class, -math)

##문제10##
mpg %>% filter(manufacturer == "audi") %>% arrange(-highway) %>% head(3)


### mutate 함수 실습 ###
exam <- exam %>% mutate(total = math + english + history)
exam <- exam %>% mutate(average = (math + english + history)/3)
exam$total <- NULL
exam$average <- NULL
exam <- exam %>% mutate(total = math + english + history, average = (math + english + history)/3)
exam$average <- round(exam$average, digits = 2)
exam <- exam %>% mutate(test = ifelse(total >= 180, "pass", "fail"))
table(exam$test)

##문제 11~13##
mpg <- mpg %>% mutate(sum = city + highway)
mean(mpg$sum)
mpg %>% 
  mutate(avg = (city + highway)/2) %>% 
  arrange(-avg) %>% 
  head(3)
mpg <- mpg %>% mutate(avg = (city + highway)/2)
mpg %>% arrange(-avg) %>% head(3)


### group_by & summarise 함수 실습 ###
exam %>% group_by(class) %>% summarise(n(), mean(math), sd(math))
exam_clsmath <- exam %>% group_by(class) %>% summarise(count = n(), mean_math = mean(math), sd_math = sd(math))
exam_clshist <- exam %>% group_by(class, gender) %>% summarise(count = n(), mean_hist = mean(history))
sum(exam_clshist$count)
exam_clshist <- exam_clshist %>% mutate(perc = count / sum(count)) #perc는 반별 성비 관련 변수#
exam_clshist <- exam_clshist %>% mutate(prop = count / sum(exam_clshist$count)) #prop는 전체 학생대비 비율 변수#

##문제 14~17##
mpg %>% group_by(manufacturer, drv) %>% summarise(mean(city), mean(highway)) %>% print(n=100)
mpg %>% group_by(manufacturer) %>% filter(class == "suv") %>% summarise(mean_sum = mean(sum)) %>% arrange(-mean_sum) %>% head(3)
mpg %>% group_by(trans) %>% summarise(mean_displ = mean(displ)) %>% arrange(-mean_displ) %>% head(3)
mpg %>% group_by(manufacturer) %>% filter(cyl == 4) %>% summarise(count = n()) %>% arrange(-count) %>% head(3)


### left_join 함수 실습 ###
exam$id <- NULL
v1 <- c(1:30)
exam <- exam %>% mutate(id = v1)
exam <- exam %>% relocate(id, .before = address)
exam <- exam %>% relocate(english, .after = math)

exam_science <- read.csv("exam_science.csv", stringsAsFactors = F)
exam <- left_join(exam, exam_science, by = "id")
exam <- exam %>% relocate(Science, .before = total)


## 문제18~20 ##
fuel_price <- data.frame(fuel = c("CNG", "diesel", "ethanol", "premium", "regular"), fuel_price = c(2.35, 2.38, 2.11, 2.76, 2.22))
mpg$fuel <- as.factor(mpg$fuel)
str(mpg$fuel)
str(fuel_price$fuel)
mpg <- left_join(mpg, fuel_price, by = "fuel")
mpg$fuel <- ifelse(mpg$fuel == "e", "ethanol", mpg$fuel)
drv_price <- data.frame(driving = c(4, "forward", "rear"), drv_price = c(40000, 30000, 50000))
mpg <- mpg %>% rename(drv = drearv)
mpg <- left_join(mpg, drv_price, by = c("drv" = "driving"))
mpg <- mpg %>% relocate(fuel_price, .after = fuel)
mpg <- mpg %>% relocate(drv_price, .before = city)

### bind_rows 함수 실습 ###
exam_add <- read.csv("exam_add.csv", stringsAsFactors = F)
exam <- bind_rows(exam, exam_add)
exam <- exam %>% distinct(id, total, .keep_all = T)

## 문제21~23 ##
exam <- exam %>% distinct(class, address, total, .keep_all = T)
exam_new <- exam
exam_new$average <- ifelse(is.na(exam_new$average), exam_new$total/3, exam_new$average)
exam$average <- ifelse(is.na(exam$average), exam$total/3, exam$average)
exam$average <- round(exam$average, digits = 2)
mean(exam$science, na.rm = T)
exam$science <- ifelse(is.na(exam$science), 80.17, exam$science)


### midwest data 실습 ###
##문제1##
library(ggplot2)
midwest <- ggplot2::midwest
##문제2##
midwest <- midwest %>% mutate(percyouth = (1 - popadults/poptotal)*100)
##문제3##
midwest %>% select(county, percyouth) %>% arrange(-percyouth) %>% head(5)
##문제4##
midwest <- midwest %>% mutate(group = ifelse(percyouth >= 40, "large", ifelse(percyouth >= 30, "middle", "small")))
table(midwest$group)
##문제5##
midwest_add <- read.csv("midwest_add.csv", stringsAsFactors = F)
midwest <- left_join(midwest, midwest_add, by = c("county" = "region"))
##문제6##
midwest <- midwest %>% distinct(PID, county, state, .keep_all = T)
##문제7##
table(midwest$state)
midwest %>% group_by(state) %>% filter(!is.na(senior)) %>% summarise(sum_senior = sum(senior))
##문제8##
install.packages("tidyr")
library(tidyr)
table(is.na(midwest$senior))
midwest <- midwest %>% drop_na()
##문제9##
midwest %>% group_by(category) %>% summarise(mean_popasian = mean(popasian)) %>% arrange(mean_popasian) %>% head(3)
midwest %>% select(inmetro:last_col())
