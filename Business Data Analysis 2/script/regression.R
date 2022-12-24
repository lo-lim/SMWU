install.packages("readr")
library(readr)
bicycle <- read_csv("bicycle.csv")


#### EDA 데이터에 대한 탐색적 검토 실행###
### 척도와 기술통계랑 확인###
str(bicycle)
library(dplyr)
glimpse(bicycle)
summary(bicycle)

### 빈도 확인 및 유형별 평균값 비교###
library(descr)
freq(bicycle$season)
freq(bicycle$holiday)
freq(bicycle$working)
freq(bicycle$weather)
2.603e+01= 2.603*10=26.03
#즉 01은 10의1승 02는 10의 2승 03은 10의 3승 

library(dplyr)
bicycle %>%group_by(season) %>% 
  summarise(mean_total=mean(total, na.rm=T))
bicycle %>%group_by(weather) %>% 
  summarise(mean_total=mean(total, na.rm=T))
bicycle %>%group_by(season, weather) %>% 
  summarise(mean_total=mean(total, na.rm=T))

### 이상치 확인 ###
boxplot(bicycle$temp)
boxplot(bicycle$atemp)
boxplot(bicycle$humidity)
boxplot(bicycle$windspeed)
boxplot(bicycle$total)

library(psych)
descriptive <- describe(bicycle)


### 데이터 전처리 ###
### 척도 변경 ###
bicycle$season <- as.factor(bicycle$season)
bicycle$holiday <- as.factor(bicycle$holiday)
bicycle$working <- as.factor(bicycle$working)
bicycle$weather<- as.factor(bicycle$weather)
bicycle$time <- as.POSIXct(bicycle$time)
str(bicycle)
table(bicycle$season)
table(bicycle$weather)
bicycle$season <- factor(bicycle$season, 
                         levels=c("spring", "summer", "fall", "winter"))
bicycle$weather <- factor(bicycle$weather, 
                         levels=c("sunny", "cloudy", "weak rain snow", "strong rain snow"))



### NA 처리 ###
summary(bicycle)
bicycle$total <- ifelse(is.na(bicycle$total), bicycle$casual+bicycle$registered, bicycle$total)
# 변수 total 값들 중에서 na는 casual+registered 값으로 대체 
table(is.na(bicycle$total))

library(tidyr)
bicycle <- bicycle %>% drop_na()

### 이상치 처리 ###
descriptive <- descriptive %>% mutate(LL=mean-3*sd, UL=mean+3*sd)
table(bicycle$total>=735.055760)
bicycle <- bicycle %>% filter(total<735.055760)

### 새로운 변수 만들기###
bicycle <- bicycle %>% mutate(difference=registered-casual)

library(dplyr)
library(tidyr)
library(psych)

#### 다중회귀분석 실습####
### 1) 상관분석 실행###
corr.test(bicycle[,c(7:14)], method = "pearson",
          alpha = 0.05, use="pairwise.complete.obs")
#bicycle 데이터프레임에서 모든 행에서 7열~14열까지
#---->결과:2p-value가 알파인 0.05와 비교했을 때 대부분의 값이 0이므로 모든 변수들 간에 상관관계와 상관계수 추정치가 통계적으로 유의하다. (2p-value<0.05)
#가장 강한 양의 상관관계:temp & atemp(0.99)

### 2) 연구가설 수립###
# IV: temp, atemp, humidity, windspeed, difference & DV: total 

#H1: temp -> total(+) #temp는 total에 양의 인과관계를 미친다/두 변수간에는 양의 인과관계를 갖고 있다./temp가 높아질 수록 total도 높아진다. 
#H2: atemp -> total(+)
#H3: humidity -> total(-)
#H4: windspeed -> total(+)
#H5: difference -> total(+)

### 3) 다중회귀식 수립###
lm1 <- lm(total~temp+atemp+humidity+windspeed+difference, data=bicycle)
#Yi(hat)=a + b1X1i + b2X2i + .... + b5X5i
#X1i=temp.....X5i=difference

### 4) 다중회귀분석 전제조건 확인:plot 함수 활용###
plot(lm1)

#residuals vs fitted:빨간색 선이 하얀색 점선을 따라서 일직선이어야 선형성 조건 만족(그렇지 않음)#
#normal Q-Q: 점들이 대각선 위에 존재하면 정규성 조건 만족(그렇지 않음)
#scale-location: 빨간색 선이 일직선이어야 등분산성과 선형성 조건 만족(그렇지 않음)
#residuals vs leverage: leverage는 사례가 다른 사례로부터 떨어진 정도로 0에 가까울 수록 바람직함. 일부 사례가 떨어져 존재하여 이상치로 볼 수도 있음. 빨간선은 수평의 일직선이 바람직함(등분산성). cook's distance는 0.5나 혹은 1을 넘으면 해당 사례가 회귀계수 추정치에 지나치게 많은 영향을 미침(그런 사례가 없음)
#6720, 6721, 6722, 8915, 8917, 8918을 제거하면 선형성/정규성/등분산성이 개선됨(각 case 번호는 6728,6729..)

bicycle <- bicycle %>% filter(case !=6728, case !=6729, case !=6730, case !=9004, case !=9006, case !=9007)
lm1 <- lm(total~temp+atemp+humidity+windspeed+difference, data=bicycle) #6개 사례 제외한 bicycle로 업데이트 

### 5) 정규성 조건 확인 ###
ks.test(bicycle$total, pnorm, 
        mean=mean(bicycle$total), sd=sd(bicycle$total))
#Kolmogorov-Smirnov test: n이 클 때 정규성 검토. 2p-value=0 <0.05 즉 유의하기에 정규성 조건 만족 못함.

shapiro.test(bicycle$total)
#shapiro.test: n이 작을 때 정규성 검토(현재는 n이 10723이기에 실행하면 오류가 뜸) 

hist(bicycle$total, breaks = seq(0,1000,10))
hist(log(bicycle$total), breaks = seq(0,10,0.1))
#log: 밑이 e(무리수)인 자연로그 

### 6) 독립성(오차의 자기상관) 검토###
library(car)
durbinWatsonTest(lm1)
#오차는 서로 양의(0.9153073) 자기상관 존재(p-value=0 혹은 rho !=0, 즉 상관관계가 있고 독립성이지 않는다.)
#DW가 0.1693747로 2보다 많이 멀리 떨어져 있는데 이 값이 0에 가깝기에 오차의 양의 자기 상관이 존재한다.(4에 가까우면 음의 자기 상관 존재) 


### 다중회귀식 추정 결과를 통한 가설검정 ###
summary(lm1)
# 회귀계수 추정치(bj)의 부호를 확인해야 함.확인 결과 예상대로 부호가 도출됨
# 현재 도출된 p-value는 2p-value임. 단측검정을 해야 하므로 2p-value와 0.1(=2*alpha) 비교해야 함
# H1채택(beta1>0)/H2채택(beta2>0)/H3채택(beta3<0)/H4 기각(beta4=0)/H5 채택(beta5>0)

#추정된 다중회귀식: Yi(hat)= 44.630 + 1.125x1i + 4.129x2i - 1.608x3i + 1.030x5i

# R2= 0.7612 & 수정 R2 0.7611 


### 모형적합도 제고를 위한 다중회귀식 추정 방법 ###
lm1_f <- step(lm1, direction = "forward") #IV를 하나씩 추가해서 추정하는 방법. AIC(모형적합도 지표)가 가장 작은값이 되도록 추정 
lm1_b <- step(lm1, direction = "backward") #처음에 모든 IV를 추가하고, IV를 하나씩 제외하고 추정하는 방법. AIC(모형적합도 지표)가 가장 작은값이 되도록 추청
lm1_s <- step(lm1, direction = "both") # foward & backward 혼합 방법. AIC(모형적합도 지표)가 가장 작은값이 되도록 추청

summary(lm1_f)
summary(lm1_b)
summary(lm1_s)
#f/b/s/ 모든 방법에서 AIC=94349.55로 동일함. 따라서 세 방법 중 어느 하나를 택하면 됨. 이때 모든 IV가 포함된 다중회귀식이 가장 모형적합도가 높음(3가지 방법다 모든 IV를 다 포함한 상태가 AIC가 가장 낮게 나옴. 만약 하나 씩 변수를 제거하면 AIC의 값이 조금씩 증가함.)

### 다중공선성 확인 ###
library(car)
vif(lm1)
#VIF>5.3 temp & atemp. 이 두 IV가 다중공선성을 일으킴
#atemp를 제거: VIF가 가장 크고, temp로 일정 부분 대체될 수 있음

lm2 <- lm(total~temp+humidity+windspeed+difference, data = bicycle)
vif(lm2)
summary(lm2)
#원칙적으로는 lm2에 대해서 전제조건 확인부터 다시 진행 

lm3<- lm(total~humidity+windspeed+difference, data = bicycle)
# temp와 atemp IV 모두 제거(일반적인 방식은 아님. 원칙적으로는 변수는 하나씩 제거해야 함.)
vif(lm3)
summary(lm3)
#만약 lm3로 가설검정하면, H4는 회귀계수 추정치의 부호가 반대이므로 유의하더라도 채택할 수 없음(원래는 회귀계수 추정치가 양수로 나와야함.)

### IV의 중요도###
# 표준화 회귀계수 추정치의 절대값 크기 비교#
install.packages("lm.beta")
library(lm.beta)
lm.beta(lm1)
#유의하지 않은 bj에 대해서는 표준화 회귀계수 추정치는 무시(즉 유의하지 않은 windspeend는 무시)
#절대값: difference>atemp>humidity>temp
#(종속변수를 가장 잘 설명해 주는 독립변수가 difference이고 temp는 가장 설명력이 떨어지는 변수 )
lm.beta(lm3)
#절대값: difference>>humidity>windspeed(H4는 기각이지만(부호가 반대로 나왔으니),b4는 유의하므로(2p-value<0.1))


### 새로운 IV 추가 타당성 검토###
#working 변수는 형태상 범주형 척도지만 내용상 더미변수. 이대로 추가할 수 있음
lm4<- lm(total~humidity+windspeed+difference+working, data = bicycle)

summary(lm3) #R-squared:  0.6947 & Adjusted R-squared:  0.6946 
summary(lm4) #R-squared:  0.7432 & Adjusted R-squared:  0.7431
# 수정 R2는 증가했고, R2 변화량= 0.0485(통계적으로 유의한지 확인해야 함)
anova(lm3, lm4)
# F-통계량= 2.024.7이고, 이때 p-value=0(2.2e-16 ***). 따라서 R2 변화량은 통계적으로 의미 있음 
# 따라서 lm3보다 lm4가 설명력이 더 좋음. working을 추가하는 것이 바람직함. 

### lm4에 대한 추정결과 ###
summary(lm4)
#working 출력순서: No, Yes. 앞에 출력되는 집단(구분)을 reference ---> No를 0으로, Yes를 1로. 즉 workingNo가 reference
#Yi(hat)= 209.867 - 1.625X3i - 0.212X4i + 1.166X5i - 80.953dv1i 
# dvi=0(No) vs dvi=1(Yes) 언제 Yi(hat)이 더 클까요? dvi=0일 때 더 큼. --> 근무를 하지 않을 때 대여회수가 더 증가함 

str(bicycle$working)
str(bicycle$season) #출력순서대로 숫자 1부터 4를 부여함 

### 새로운 독립변수 추가(season) 타당성 검토###
summary(bicycle$season)
lm5<- lm(total~humidity+windspeed+difference+working+season, data = bicycle) #season과 관련해서 4-1=3개의 더미변수 생성/ 제일 먼저 출력되는 spring이 reference
summary(lm4) # 수정R2=0.7431& R2=0.7432
summary(lm5) # 수정R2=0.7778& R2=0.778(0.0348 증가)
anova(lm4,lm5) # F-통계량= 559.18이고, 이때 p-value=0(2.2e-16 ***)<alpha 따라서 R2 변화량은 통계적으로 의미 있음 
# 따라서 lm4보다 lm5가 설명력(GOF)이 더 좋음. season을 추가하는 것이 바람직함. 
summary(lm5)
#Yi(hat)= 172.680 - 1.809X3i + 1.136X5i - 78.929dv1i + 68.971dv2i + 81.501dv3i + 36.710dv4i/ 기존 독립변수의 회귀계수 추정치의 유의성은 2p-value와 2alpha인 0.1올 비교하고, 네 개의 더미변수 회귀계수 추정치는 2p-value와 alpha인 0.05를 비교 
#season이 summer, fall, winter일 때 reference인 spring에 비해 전체 대여회수가 각각의 Estimate만큼 늘어난다.(dvi의 값이 0인 spring보다 1일 때 값이 더 크기에, ex) seasonsummer일 때는 reference인 seasonspring일 때보다 자전거 대여회수가 68.971만큼 늘어난다.)
#기존 독립변수들은 방향이 있음(양으로 영향을 미치는지, 음으로 영향을 미치는지, 그래서 단측검정)/추가된 더미변수들은 방향이 없음(단지 종속변수에 영향을 미칠까 안 미칠까 확인하는 것이기에 양측검정)

# spring: 0, 0, 0/ summer 1, 0, 0/ fall: 0, 1, 0/ winter: 0, 0, 1
# spring: Yi(hat)= 172.680 - 1.809X3i + 1.136X5i - 78.929dv1i + 0
# summer: Yi(hat)= 172.680 - 1.809X3i + 1.136X5i - 78.929dv1i + 68.971
# fall: Yi(hat)= 172.680 - 1.809X3i + 1.136X5i - 78.929dv1i + 81.501
#winter: Yi(hat)= 172.680 - 1.809X3i + 1.136X5i - 78.929dv1i + 36.710

library(car)
vif(lm5) # GVIF^(1/(2*Df)) 값이 2보다 작으면 다중공선성은 문제 없음 

### 새로운 독립변수 atemp 추가 문제 확인###
lm6<- lm(total~humidity+windspeed+difference+working+season+atemp, data = bicycle)
summary(lm5)
summary(lm6) # 수정R2=0.8098& R2=0.810(0.032 증가)
anova(lm5, lm6) # F-통계량= 1804.2이고, 이때 p-value=0(2.2e-16 ***)<alpha 따라서 R2 변화량은 통계적으로 의미 있음 #lm5보다 lm6의 GOF이 좋다.
vif(lm6)

summary(lm6)
library(lm.beta)
lm.beta(lm6)
# dv2i~dv4i는 중요도가 매우 떨어짐. 새로 추가된 atemp는 중요도가 2위. 중요도가 떨어지는 독립변수는 회귀계수 추정치가, 다른 중요도가 높은 IVs(독립변수들)에 영향을 받아서 왜곡될 수 있음./ b8(seasonfall)이 예상과 달리 음으로 유의하게 추정됨.

### lm5에 기반하여 IVs 측정값이 존재할 경우 종속변수 (예측치)를 예측하기 ###
#temp:32.2/ atemp:35.4/ humidity:65.7/ windspeed: 6.5/ difference:120/working:Yes/ season:summer

172.680 - 1.809*65.7 + 1.136*120 - 78.929*1 + 68.971*1 + 81.501*0 + 36.710*0

#종속변수(예측치)는 181.191

### 조절효과 확인하기 ###
# Model1: IVs와 DV로만 구성-lm3 (humidity+windspeed+difference)
# Model2: Model1에 MV(working)를 추가해서 구성-lm4 (humidity+windspeed+difference+working)
# Model3: Model2에 상호작용변수(humidity*working)를 추가해서 구성-lm7
# lm4와 lm7 비교해서 lm7의 설명력이 더 좋은지 확인해야 함

str(bicycle$working)
str(bicycle$humidity)
bicycle$working <- as.numeric(bicycle$working)

library(dplyr)
bicycle <- bicycle %>% mutate(inter=humidity*working) #상호작용변수 만들기
lm7 <- lm(total~humidity+windspeed+difference+working+inter, data=bicycle) 
anova(lm4,lm7) #R2 변화량=0.0122는 유의함 
summary(lm4) #R2=0.7432 & 수정R2=0.7431 
summary(lm7) #R2=0.7554 & 수정R2=0.7553
# lm4보다 lm7의 모형적합도(설명력)가 더 좋음. lm7채택
# H3에서 humidity가 total (-) 인과관계를 설정. b3= -5.601 예상대로 음수로 유의함./b7=inter, 기존 인과관계가 강화(b7<0 유의) 혹은 약화(b7>0유의)
# H6: humidity와 total에 대한 음의 인과관계에 working의 조절효과가 존재한다. (b7이 양수인지, 음수인지 지정하지 않음-->양측검정, 즉 inter의 회귀계수 추정치가 유의한지의 여부를 검증할 때, 2p-value와 alpha인 0.05와 비교) 
# b7=2.044 양수로 유의함. 따라서 기존 인과관계를 약화 
#습도가 높아지면 대여회수가 줄어들지만, 일하는 시기 (Working=Yes)에는 줄어드는 정도가 완화된다. 예를 들면, 습도가 20인데 일을 안하면(상호작용변수값(inter)=20)대여회수가 100회인데 일을 하면(상호작용변수값(inter)=40) 대여회수가 110회로 조금 덜 줄어드는 것./일을 안 하면 1이고 하면 2니까 inter=humidity*working에서 일을 안하면 20*1=20, 일을 
