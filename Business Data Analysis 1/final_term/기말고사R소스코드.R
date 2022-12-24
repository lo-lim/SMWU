library(readr)
library(dplyr)
library(psych)
library(forcats)
library(agricolae)
library(dunn.test)
library(car)
library(HH)

finalexam<- read_csv("finalexam.csv", locale = locale('ko', encoding = 'euc-kr'))
finalexam <- finalexam %>% mutate(d = glucosebefore- glucoseafter)
shapiro.test(finalexam$d)
t.test(finalexam$glucosebefore, finalexam$glucoseafter, alternative = "two.sided", paired = T)

finalexam <- finalexam %>% mutate(ageg = case_when(age<25~"young", age<40~"middle", age>=40~"prime"))

round(0.9564, digits = 4)
round(21.094, digits = 4)
round(19.83 , digits = 4)

leveneTest(bloodpressure~ageg, data = finalexam)

finalexam_result <- aov(bloodpressure~ageg, data = finalexam)
summary(finalexam_result)


library(agricolae)
duncan.test(finalexam_result, "ageg", console = T)

round(  64.72146 , digits = 4)
round(   67.83333   , digits = 4)
round(    75.84541   , digits = 4)

two_final <- finalexam
leveneTest(BMI~diabetes, data = two_final)
round(2.3945 , digits = 3)
round(0.1222 , digits = 3)


two_final_result <- aov(BMI~diabetes, data = two_final)
summary(two_final_result)

two_final_2<- aov(BMI~diabetes*ageg, data = two_final)
summary(two_final_2)

round(3.543 , digits = 3)

library(HH)
interaction2wt(BMI~diabetes*ageg, data = two_final)

xtabs(~ageg + diabetes, two_final)
prop.table(xtabs(~ageg + diabetes, two_final), margin = 1)
chisq.test(xtabs(~ageg + diabetes, two_final))

table(two_final$ageg == "young" & two_final$diabetes == "Yes")#31#
table(two_final$ageg == "young" & two_final$diabetes == "No")
#188#
table(two_final$ageg == "middle" & two_final$diabetes == "Yes")#129#
table(two_final$ageg == "middle" & two_final$diabetes == "No")#213#

prop <- matrix(c(31, 188, 129, 213), nrow = 2, ncol = 2, byrow = T)
rownames(prop) <- c("young", "middle")
colnames(prop) <- c("Yes", "No")

prop.table(prop, margin = 1)
prop.test(prop, alternative = "two.sided", correct = T)


