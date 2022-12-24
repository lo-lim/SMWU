library(readr)
library(dplyr)
library(descr)
library(ggplot2)
library(psych)

bike <- read.csv("bike.csv")
bike_1 <- bike %>% filter(time=="1990")
bike %>% group_by(engine) %>% summarise(count=n()) %>% arrange(-count)

#3#
descr <- describe(bike$price)
descr <- descr %>% mutate(ll=mean-2.5*sd, ul=mean+2.5*sd)
table(bike$price>473875.3)
bike_n <- bike %>% filter(price<=473875.3)
round(mean(bike_n$engine, na.rm=T),2)
mean(bike_n$engine, na.rm = T)

bike_n <- bike_n %>% mutate(group=case_when(engine<=15~"weak", engine<=20~"middle", engine<=25~"good", engine>25~"strong"))
table(bike_n$group)
            
#6#
descr <- describe(bike_n$driving)
descr <- descr %>% mutate(ll=mean-3*sd, ul=mean+3*sd)
bike_0 <- bike_n %>% filter(driving<=131341.2)

#7#
bike_0 %>% group_by(group) %>% summarise(mean=mean(driving)) %>% arrange(mean)

#8#
hist(bike_0$driving, breaks =seq(0,130000,5000))

#9-2#
bike_s <- bike_0 %>% filter(group=="strong")
bike_g <- bike_0 %>% filter(group=="good")
shapiro.test(bike_s$price)
shapiro.test(bike_g$price)

#9-3#
var.test(bike_s$price, bike_g$price)

#9-4#
t.test(bike_s$price, bike_g$price, alternative="two.sided", var.equal=F)

#10-2#
bike_m <- bike_0 %>% filter(group=="middle")
bike_w <- bike_0 %>% filter(group=="weak")
shapiro.test(bike_m$driving)
shapiro.test(bike_w$driving)

#10-3#
var.test(bike_m$driving, bike_w$driving)

#10-4#
t.test(bike_m$driving, bike_w$driving, alternative="two.sided", var.equal=F)
