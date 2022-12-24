library(readr)
library(dplyr)
library(descr)

credit <- read_csv("credit.csv")

credit %>% group_by(gender,purpose) %>% summarise(mean_credit=mean(credit,na.rm=T))

credit$purpose <- factor(credit$purpose, levels = c("working", "credit", "house"))
table(credit$purpose)

credit <- credit %>% mutate(group=ifelse(asset <= 20000,"C",ifelse(asset <=40000,"B",ifelse(asset <=60000,"A","S" ))))
table(credit$group)
credit %>% group_by(group) %>% summarise(credit_mean=mean(credit, na.rm=T))

str(credit)
summary(credit)
corr.test(credit[,c(2:6)], method = "pearson",
          alpha = 0.05, use="pairwise.complete.obs")

lm1 <- lm(credit~age+asset+income+duration, data=credit)
plot(lm1)
credit <- credit %>% filter(id!=379, id!=638, id!=888, id!=916, id!=918)
lm1 <- lm(credit~age+asset+income+duration, data=credit)
shapiro.test(credit$credit)
library(car)
durbinWatsonTest(lm1)

summary(lm1)

lm1_f <- step(lm1, direction = "forward")
lm1_b <- step(lm1, direction = "backward")
lm1_s <- step(lm1, direction = "both")
summary(lm1_f)
summary(lm1_b)
summary(lm1_s)

vif(lm1)

lm2 <- lm(credit~age+asset+income+duration+purpose, data=credit)
summary(lm1)
summary(lm2)
0.6264-0.6234
anova(lm1,lm2)

summary(lm2)

library(lm.beta)
lm.beta(lm2)

lm3<- lm(credit~age+asset+income+duration+purpose+gender, data=credit)
summary(lm2)
summary(lm3)
0.6284-0.6264
anova(lm2,lm3)

summary(lm3)

table(credit$gender)
credit_male <- credit %>% filter(gender=="male")
credit_female <- credit %>% filter(gender=="female")
lm_male <- lm(credit~age+asset+income+duration+purpose, data=credit_male)
lm_female <- lm(credit~age+asset+income+duration+purpose, data=credit_female)
summary(lm_male)
summary(lm_female)
anova(lm_male, lm_female)


