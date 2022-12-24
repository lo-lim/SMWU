library(dplyr)
library(ggplot2)

ggplot(mpg, aes(displ, highway)) + geom_point() + xlim(3, 6) + ylim(20, 30)
ggplot(mpg, aes(displ, highway, color = fuel)) + geom_point()
ggplot(mpg, aes(displ, highway, color = drv)) + geom_point(aes(shape = drv, size = fuel))
ggplot(mpg, aes(displ, highway, color = drv)) + geom_point(aes(shape = drv))

### mpg 실습문제 ###
ggplot(mpg, aes(city, highway)) + geom_point()
ggplot(mpg, aes(city, highway)) + geom_point() + xlim(0, 30) + ylim(0, 40)
ggplot(mpg, aes(city, highway, color = cyl)) + geom_point() + xlim(0, 30) + ylim(0, 40)
ggplot(mpg, aes(city, highway, color = cyl)) + geom_point(aes(shape = drv)) + xlim(0, 30) + ylim(0, 40)
ggplot(mpg, aes(city, highway, color = cyl)) + geom_point(aes(shape = drv)) + xlim(0, 30) + ylim(0, 40) + geom_smooth()

### midwest 실습문제 ###
ggplot(midwest, aes(poptotal, popasian)) + geom_point()
ggplot(midwest, aes(poptotal, popasian)) + geom_point() + xlim(0, 350000) + ylim(0, 5000)
ggplot(midwest, aes(poptotal, popasian, color = state)) + geom_point(aes(shape = state)) + xlim(0, 350000) + ylim(0, 5000) + geom_smooth()

### 막대 그래프 그리기 ###
library(dplyr)
library(ggplot2)

df_mpg <- mpg %>% group_by(drv) %>% summarise(mean_sum = mean(sum))
ggplot(df_mpg, aes(drv, mean_sum)) + geom_bar(stat = "identity")
ggplot(df_mpg, aes(reorder(drv, -mean_sum), mean_sum)) + geom_bar(stat = "identity")
ggplot(df_mpg, aes(reorder(drv, -mean_sum), mean_sum, fill = drv)) + geom_bar(stat = "identity")

ggplot(mpg, aes(class)) + geom_bar()
ggplot(mpg, aes(highway)) + geom_bar()
ggplot(mpg, aes(class, fill = class)) + geom_bar()
ggplot(mpg, aes(class, fill = class)) + geom_bar() + xlim(c("compact", "midsize", "suv"))
ggplot(mpg, aes(class, fill = class)) + geom_bar() + coord_flip()
ggplot(mpg, aes(class, fill = class)) + geom_bar() + coord_polar()

ggplot(mpg, aes(class, fill = fuel)) + geom_bar()
ggplot(mpg, aes(class, fill = fuel)) + geom_bar(position = "dodge")
ggplot(mpg, aes(class, fill = fuel)) + geom_bar(position = "fill")

mpg_suv <- mpg %>% group_by(manufacturer) %>% filter(class == "suv") %>% summarise(mean_city = mean(city)) %>% arrange(-mean_city) %>% head(5)
ggplot(mpg_suv, aes(reorder(manufacturer, mean_city), mean_city, fill = manufacturer)) + geom_bar(stat = "identity") + coord_flip() + labs(title = "회사별 suv 도심연비 평균 비교", x = "제조사", y = "suv 도심연비 평균")


### 히스토그램 그리기 ###
ggplot(mpg, aes(highway)) + geom_histogram()
ggplot(mpg, aes(highway)) + geom_histogram(binwidth = 1, fill = "yellow", color = "skyblue2") + labs(title = "고속도로연비 히스토그램", x = "고속도로연비", y = "빈도")

colors()

### 선 그래프 그리기 ###
library(dplyr)
library(ggplot2)
economics <- ggplot2::economics
str(economics)

ggplot(economics, aes(date, unemploy)) + geom_line()
ggplot(economics, aes(date, unemploy)) + geom_line() + geom_point()
ggplot(economics, aes(date, unemploy)) + geom_line(color = "red") + geom_point(color = "blue4")


### 상자 그래프 그리기 ###
ggplot(mpg, aes(drv, highway, fill = drv)) + geom_boxplot()
ggplot(mpg, aes(drv, highway, fill = drv)) + geom_boxplot(outlier.color = "red")
ggplot(mpg, aes(drv, highway, fill = drv)) + geom_boxplot(outlier.color = "red") + stat_summary(fun = "mean", geom = "point")


### corona19 그래프 그리기 ###
corona19 <- read.csv("corona19.csv", stringsAsFactors = F)
str(corona19)
corona19$date <- as.Date(corona19$date)
summary(corona19)

ggplot(corona19, aes(new_tests, new_cases)) + geom_point()
ggplot(corona19, aes(new_tests, new_cases)) + geom_point() + xlim(10000, 60000) + ylim(0, 3000) + geom_smooth()
ggplot(corona19, aes(date, new_cases, fill = new_cases)) + geom_bar(stat = "identity")

ggplot(corona19, aes(date, new_cases)) + geom_line(color = "red") + geom_point(color = "blue")
ggplot(corona19, aes(date, new_deaths)) + geom_line(color = "red") + geom_point(color = "blue")
ggplot(corona19, aes(date, total_deaths)) + geom_line(color = "red") + geom_point(color = "blue")
ggplot(corona19, aes(date, positive.rate)) + geom_line(color = "red") + geom_point(color = "blue")
ggplot(corona19, aes(date, reproduction.rate)) + geom_line(color = "red") + geom_point(color = "blue")
ggplot(corona19, aes(date, people_fully_vaccinated)) + geom_line(color = "red") + geom_point(color = "blue")

corona19_new <- read.csv("corona19_new.csv", stringsAsFactors = F)
corona19_new$date <- as.Date(corona19_new$date)
ggplot(corona19_new, aes(date, number, color = type)) + geom_line() + geom_point()
