library(readr)
bike <- read_csv("bike.csv", col_names = T, locale=locale('ko', encoding='euc-kr'))
library(dplyr)

#문제 1#
bike <- bike %>% mutate(eng=case_when(engine<14~"C", engine<19.5~"B", engine<24~"A", engine>=24~"S"))
bike %>% group_by(eng) %>% summarise(count=n())

#문제 2#
HO: 4가지 집단의 price 모평균이 같다
HA: 적어도 한 집단의 price 모평균은 다른 집단과 다르다

#문제 3#
bike_C<- bike %>% filter(eng=="C")
bike_B <- bike %>% filter(eng=="B")
bike_A<- bike %>% filter(eng=="A")
bike_S <- bike %>% filter(eng=="S")
shapiro.test(bike_A$price)
shapiro.test(bike_B$price)
shapiro.test(bike_C$price)
shapiro.test(bike_S$price)
round(0.87507, digits = 3)
round(0.61661, digits = 3)
round(0.55003, digits = 3)
round(0.64011, digits = 3)

#문제 4#
library(car)
leveneTest(price~eng, data=bike)

#문제 5#
oneway.test(price~eng, data=bike)

#문제 6#
library(dunn.test)
dunn.test(bike$price, bike$eng, method = "bonferroni")


