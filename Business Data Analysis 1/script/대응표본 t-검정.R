#### 대응표본 t-검정 ####
### STEP1: 가설수립 ###

### STEP2: 차이 변수 만들기 ###
pttest <- read_csv("pttest.csv", locale = locale('ko', encoding = 'euc-kr'))
pttest <- pttest %>% mutate(d = morning - weekend)

### STEP3: d의 정규성 검토 ###
shapiro.test(pttest$d)

### STPE4: 가설검정 ###
t.test(pttest$morning, pttest$weekend, alternative = "two.sided", paired = T)