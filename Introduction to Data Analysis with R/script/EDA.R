### csv 파일 불러와서 데이터 프레임 만들기 ###
exam <- read.csv("exam.csv", stringsAsFactors = F)

### 여섯 개 함수로 탐색적 검토하기 ###
head(exam, 10)
tail(exam, 8)
head(exam$gender, 7)
View(exam)
exam$id <- NULL ##id 변수 지워주기##
dim(exam)
str(exam)
exam$address <- as.factor(exam$address) ##순차적으로 세 개 변수 척도를 문자형(혹은 정수형)에서 범주형으로 바꾸기##
exam$gender <- as.factor(exam$gender)
exam$class <- as.factor(exam$class)
summary(exam)

### 개별 기술통계량 함수 사용하기 ###
mean(exam$math)
round(mean(exam$math), digits = 2)
var(exam$math)
sd(exam$math)
var(exam$history)

### histogram 그리기 ###
hist(exam$math, breaks = seq(0, 100, by = 5))
hist(exam$history, breaks = seq(0, 100, by = 5))
hist(exam$english, breaks = seq(0, 100, by = 5))

### table 함수와 qplot 함수를 통한 빈도수 확인하기 ###
table(exam$address)
table(exam$gender)
table(exam$class)
table(exam$address, exam$gender)
table(exam$class, exam$address)

install.packages("ggplot2")
library(ggplot2)
qplot(data = exam, address, fill = gender)
qplot(data = exam, class, fill = address)

### weather 데이터 프레임으로 실습하기 ###
weather <- read.csv("weather.csv", stringsAsFactors = F) #문제1#
str(weather) #문제2#
weather$일시 <- as.Date(weather$일시)
weather$요일.구분 <- as.factor(weather$요일.구분) #문제3#

weekdays(as.Date('2020-01-01'))
weather$요일 <- weekdays(weather$일시) #문제4#
weather$요일 <- as.factor(weather$요일)
str(weather$요일) 

summary(weather) #문제5#
var(weather$일강수량, na.rm = T) #문제6#

table(weather$요일.구분)
table(weather$요일)
weather$요일 <- factor(weather$요일, levels = c("월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일")) #문제7#

qplot(data = weather, 요일, fill = 요일.구분) #문제8#
hist(weather$평균기온, breaks = seq(-20, 50, by =1))
hist(weather$평균.상대습도, breaks = seq(0, 100, by =1)) #문제9#

### 기술통계량 추가분석 ###
install.packages("pastecs")
library(pastecs)
stat.desc(exam$math)

install.packages("psych")
library(psych)
describe(exam$math)

### excel 파일 불러오기 ###
install.packages("readxl")
library(readxl)
exam_addition <- read_excel("exam_addition.xlsx", sheet = 1)
exam_addition$id <- NULL

### 데이터 프레임 내보내기 ###
write.csv(exam, file = "exam1.csv")
install.packages("writexl")
library(writexl)
write_xlsx(exam_addition, path = "exam2.xlsx")


### 비교 연산자 ###
table(exam$address == "원효로")
table(exam$gender != "Female") #table(exam$gender == "Male")#
table(exam$math == 50)
table(exam$math != 50)
table(exam$math <= 50)
table(exam$math >= 50)

### 논리 연산자 ###
table(exam$english <= 50 & exam$history >= 80)
table(exam$math >= 90 | exam$history >= 90)
table(exam$address == "효창동" | exam$address == "청파동" | exam$address == "서계동")
table(exam$address %in% c("효창동", "청파동", "서계동"))

### 변수명 바꾸기 ###
library(ggplot2)
head(mpg)
mpg <- mpg
str(mpg)
summary(mpg)
table(mpg$drv)
table(mpg$fl)
table(mpg$class)

install.packages("dplyr")
library(dplyr)
mpg <- rename(mpg, fuel = fl, city = cty, highway = hwy)

### 측정값 바꾸기 ###
ifelse("A" == "B", "True", "False")
v1 <- 3
ifelse(v1 >= 3, "Y", "N")

mpg$drv <- ifelse(mpg$drv == "f", "forward", mpg$drv)
mpg$drv <- ifelse(mpg$drv == "r", "rear", mpg$drv)

mpg$fuel <- ifelse(mpg$fuel == "r", "regular", mpg$fuel)
mpg$fuel <- ifelse(mpg$fuel == "c", "CNG", mpg$fuel)
mpg$fuel <- ifelse(mpg$fuel == "p", "premium", mpg$fuel)
mpg$fuel <- ifelse(mpg$fuel == "e", "ethanol", mpg$fuel)
mpg$fuel <- ifelse(mpg$fuel == "d", "diesel", mpg$fuel)

### 추가 예제 ###
table(weather$평균기온 >= 27)
table(weather$평균기온 >= 10 & weather$평균기온 <= 20)

table(weather$일강수량 == 0)
summary(weather$일강수량)
table(is.na(weather$일강수량))
table(!is.na(weather$일강수량))

table(weather$요일 %in% c("월요일", "화요일", "수요일"))
table(weather$최고기온 > 30 & weather$평균.상대습도 > 80)
table(weather$최저기온 < -10 | weather$합계.일조시간 < 1)

weather_new <- weather
library(dplyr)
weather_new <- rename(weather_new, 요일구분 = 요일.구분)
weather_new <- rename(weather_new, 평균기압 = 평균.현지기압)

str(weather_new$요일구분)
weather_new$요일구분 <- factor(weather_new$요일구분, levels = c("휴일", "평일"))

weather_new$일강수량 <- ifelse(weather_new$일강수량 == 0, NA, weather_new$일강수량)
table(is.na(weather_new$평균기압))
round(mean(weather_new$평균기압, na.rm = T), digits = 2)
weather_new$평균기압 <- ifelse(is.na(weather_new$평균기압), 1006.26, weather_new$평균기압)
weather_new$평균기압 <- ifelse(is.na(weather_new$평균기압), round(mean(weather_new$평균기압, na.rm = T), digits = 2), weather_new$평균기압)