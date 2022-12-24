library(dplyr)
library(stringr)

raw_moon <- readLines("speech_moon.txt", encoding = "UTF-8")
head(raw_moon)
moon <- raw_moon %>% str_replace_all("[^가-힣]", " ")
head(moon)

moon <- moon %>% str_squish()
head(moon)

moon <- as_tibble(moon)
moon

install.packages("tidytext")
library(tidytext)
library(dplyr)
word_space <- moon %>% unnest_tokens(input = value, output = word, token = "words")

word_space <- word_space %>% count(word, sort = T)
word_space <- word_space %>% filter(str_count(word) > 1)

library(ggplot2)
top20 <- word_space %>% head(20)
ggplot(top20, aes(reorder(word, -n), n, fill = word)) + geom_bar(stat = "identity") + geom_text(aes(label = n), hjust = -0.3) + labs(title = "문재인 출마 연설문 단어 빈도") + theme(title = element_text(size = 12))

install.packages("ggwordcloud")
library(ggwordcloud)
ggplot(word_space, aes(label = word, size = n)) + geom_text_wordcloud(seed = 1234) + scale_radius(limits = c(3, NA), range = c(3, 30))
ggplot(word_space, aes(label = word, size = n, col = n)) + geom_text_wordcloud(seed = 1234) + scale_radius(limits = c(3, NA), range = c(3, 30)) + scale_color_gradient(low = "darkgreen", high = "darkred") + theme_minimal()

colors()

install.packages("showtext")
library(showtext)
font_add_google(name = "Nanum Gothic", family = "nanumgothic")
showtext_auto()

ggplot(top20, aes(reorder(word, -n), n, fill = word)) + geom_bar(stat = "identity") + geom_text(aes(label = n), hjust = -0.3) + labs(title = "문재인 출마 연설문 단어 빈도") + theme(title = element_text(size = 12), text = element_text(family = "nanumgothic"))

ggplot(word_space, aes(label = word, size = n, col = n)) + geom_text_wordcloud(seed = 1234, family = "nanumgothic") + scale_radius(limits = c(3, NA), range = c(3, 30)) + scale_color_gradient(low = "darkgreen", high = "darkred") + theme_minimal()


##### 텍스트 마이닝2 #####
install.packages("multilinguer")
library(multilinguer)
install_jdk()

install.packages(c("stringr", "hash", "tau", "Sejong", "RSQLite", "devtools"), type = "binary")

install.packages("remotes")
remotes::install_github("haven-jeon/KoNLP", upgrade = "never", INSTALL_opts=c("--no-multiarch"))
library(KoNLP)
useNIADic()

## 명사 기준 토큰화: word_noun 만들기 ##
word_noun <- moon %>% unnest_tokens(input = value, output = word, token = extractNoun)
word_noun

## 빈도수 상위 20개에 대해서 막대 그래프 그리기와 워드 클라우드 만들기 ##
word_noun <- word_noun %>% count(word, sort = T) %>% filter(str_count(word) > 1)
top20 <- word_noun %>% head(20)

# 글자체 변경 #
library(showtext)
font_add_google(name = "Black Han Sans", family = "BHS")
showtext_auto()

# 막대 그래프 그리기 #
ggplot(top20, aes(reorder(word, -n), n, fill = word)) + geom_bar(stat = "identity") + geom_text(aes(label = n), hjust = -0.3) + labs(title = "문재인 출마 연설문 명사 빈도") + theme(title = element_text(size = 12), text = element_text(family = "BHS"))

# 워드 클라우드 만들기 #
ggplot(word_noun, aes(label = word, size = n, col = n)) + geom_text_wordcloud(seed = 1234, family = "BHS") + scale_radius(limits = c(2, NA), range = c(3, 15)) + scale_color_gradient(low = "darkgreen", high = "darkred") + theme_minimal()

## 특정 단어가 포함된 문장 찾기 ##
sentences_moon <- raw_moon %>% str_squish() %>% as_tibble() %>% unnest_tokens(input = value, output = sentence, token = "sentences")
sentences_moon %>% filter(str_detect(sentence, "국민"))
sentences_moon %>% filter(str_detect(sentence, "일자리")) %>% print.data.frame(right = F)


##### 단어 빈도 비교하기 #####
library(dplyr)
## 문대통령 연설문 불러와 저장 ##
raw_moon <- readLines("speech_moon.txt", encoding = "UTF-8")
moon <- raw_moon %>% as_tibble() %>% mutate(president = "moon")

## 박전대통령 연설문 불러와 저장 ##
raw_park <- readLines("speech_park.txt", encoding = "UTF-8")
park <- raw_park %>% as_tibble() %>% mutate(president = "park")

## 두 연설문 통합과 전처리 및 토큰화 ##
bind_speeches <- bind_rows(moon, park) %>% relocate(president, .before = value)
library(stringr)
speeches <- bind_speeches %>% mutate(value = str_replace_all(value, "[^가-힣]", " "), value = str_squish(value))
library(tidytext)
library(KoNLP)
speeches <- speeches %>% unnest_tokens(input = value, output = word, token = extractNoun)

## 대통령별 단어 빈도수 구하기 ##
frequency <- speeches %>% count(president, word) %>% filter(str_count(word) > 1)

## 빈도수 상위 10개 단어 데이터 만들기 ##
top10 <- frequency %>% group_by(president) %>% slice_max(n, n = 10) %>% print(n = Inf)
top10 <- frequency %>% group_by(president) %>% slice_max(n, n = 10, with_ties = F) %>% print(n = Inf)

## 막대 그래프 그리기 ##
library(ggplot2)
ggplot(top10, aes(reorder(word, n), n, fill = president)) + geom_bar(stat = "identity") + coord_flip() + facet_wrap(~president)
ggplot(top10, aes(reorder(word, n), n, fill = president)) + geom_bar(stat = "identity") + coord_flip() + facet_wrap(~president, scales = "free_y")
# park에서 국민 단어 제외하기 #
top10 <- frequency %>% filter(word != "국민") %>% group_by(president) %>% slice_max(n, n = 10, with_ties = F) %>% print(n = Inf)
# 그래프별로 X축 항목 결과값을 다르게 하기 #
library(tidytext)
ggplot(top10, aes(reorder_within(word, n, president), n, fill = president)) + geom_bar(stat = "identity") + coord_flip() + facet_wrap(~president, scales = "free_y")
ggplot(top10, aes(reorder_within(word, n, president), n, fill = president)) + geom_bar(stat = "identity") + coord_flip() + facet_wrap(~president, scales = "free_y") + scale_x_reordered() + labs(x = NULL)


### 오즈비 구하기 ###
library(dplyr)
library(ggplot2)
library(tidyr)
library(tidytext)
library(stringr)

## long form data를 wide form data로 변경하기 ##
df_long <- frequency %>% group_by(president) %>% slice_max(n, n = 10) %>% filter(word %in% c("국민", "우리", "정치", "행복"))
df_wide <- df_long %>% pivot_wider(names_from = president, values_from = n)
df_wide <- df_long %>% pivot_wider(names_from = president, values_from = n, values_fill = list(n=0))
frequency_wide <- frequency %>% pivot_wider(names_from = president, values_from = n, values_fill = list(n=0))

## 오즈비 구하기 ##
frequency_wide <- frequency_wide %>% mutate(ratio_moon = ((moon + 1)/(sum(moon + 1))), ratio_park = ((park + 1)/(sum(park + 1))))
frequency_wide <- frequency_wide %>% mutate(odds_ratio = ratio_moon / ratio_park)
frequency_wide %>% arrange(-odds_ratio)
frequency_wide %>% arrange(odds_ratio)
frequency_wide %>% arrange(abs(1-odds_ratio))

## top10 데이터 만들기 ##
top10 <- frequency_wide %>% filter(rank(odds_ratio) <= 10 | rank(-odds_ratio) <= 10) %>% arrange(-odds_ratio)

## 막대 그래프 그리기 ##
top10 <- top10 %>% mutate(president = ifelse(odds_ratio > 1, "moon", "park"), n = ifelse(odds_ratio > 1, moon, park)) # 새로운 두 개 변수 만들기 #
ggplot(top10, aes(x = reorder_within(word, n, president), n, fill = president)) + geom_bar(stat = "identity") + coord_flip() + facet_wrap(~ president, scales = "free_y") + scale_x_reordered() + labs(x = NULL)
ggplot(top10, aes(x = reorder_within(word, n, president), n, fill = president)) + geom_bar(stat = "identity") + coord_flip() + facet_wrap(~ president, scales = "free") + scale_x_reordered() + labs(x = NULL) # 그래프별로 축 설정하기 #

## 주요 단어가 사용된 문장 살펴보기 ##
speeches_sentence <- bind_speeches %>% as_tibble() %>% unnest_tokens(input = value, output = sentence, token = "sentences")
speeches_sentence %>% filter(president == "moon" & str_detect(sentence, "복지국가"))
speeches_sentence %>% filter(president == "park" & str_detect(sentence, "행복"))
frequency_wide %>% arrange(abs(1 - odds_ratio)) %>% head(10)
frequency_wide %>% filter(moon >= 5 & park >= 5) %>% arrange(abs(1 - odds_ratio)) %>% head(10)


### 로그오즈비 구하기 ###
library(dplyr)
library(ggplot2)
library(tidyr)
library(tidytext)
library(stringr)

## 로그오즈비 변수 만들기 ##
frequency_wide <- frequency_wide %>% mutate(log_odds_ratio = log(odds_ratio))

## top10 데이터 만들기 ##
top10 <- frequency_wide %>% group_by(president = ifelse(log_odds_ratio > 0 , "moon", "park")) %>% slice_max(abs(log_odds_ratio), n = 10, with_ties = F)

## 막대그래프 그리기 ##
ggplot(top10, aes(reorder(word, log_odds_ratio), log_odds_ratio, fill = president)) + geom_bar(stat = "identity") + coord_flip() + labs(x = NULL)

## TF-IDF 구하기 ##
install.packages("readr")
library(readr)
raw_speeches <- read_csv("speeches_presidents.csv")

speeches <- raw_speeches %>% mutate(value = str_replace_all(value, "[^가-힣]", " "), value = str_squish(value))
library(KoNLP)
speeches <- speeches %>% unnest_tokens(input = value, output = word, token = extractNoun)
frequency_four <- speeches %>% count(president, word) %>% filter(str_count(word) > 1)

frequency_four <- frequency_four %>% bind_tf_idf(term = word, document = president, n = n) %>% arrange(-tf_idf)
frequency_four %>% filter(president == "노무현")
frequency_four %>% filter(president == "이명박")

## 막대그래프 그리기 ##
top10 <- frequency_four %>% group_by(president) %>% slice_max(tf_idf, n = 10, with_ties = F)
str(top10)
top10$president <- factor(top10$president, levels = c("문재인", "박근혜", "이명박", "노무현"))
ggplot(top10, aes(reorder_within(word, tf_idf, president), tf_idf, fill = president)) + geom_bar(stat = "identity") + coord_flip() + facet_wrap(~president, scales = "free") + scale_x_reordered() + labs(x = NULL)


#### 감정분석 ####

### 감정 사전 활용하기 ###
## 감정 사전 만들고 검토하기 ##
library(dplyr)
library(readr)
dic <- read_csv("knu_sentiment_lexicon.csv")

library(stringr)
dic %>% filter(!str_detect(word, "[가-힣]")) %>% arrange(word) %>% print(n = Inf)
dic %>% filter(str_detect(word, "고마운")) %>% arrange(word)
dic %>% filter(str_detect(word, "얄미운")) %>% arrange(word)

dic %>% mutate(sentiment = ifelse(polarity >= 1, "pos", ifelse(polarity <= -1, "neg", "neu"))) %>% count(sentiment)

## 문장 감정 점수 구하기 ##
df <- tibble(sentence = c("디자인 예쁘고 마감도 좋아서 만족스럽다", "디자인은 괜찮다. 그런데 마감이 나쁘고 가격도 비싸다."))

library(tidytext)
df <- df %>% unnest_tokens(input = sentence, output = word, token = "words", drop = F)
df <- left_join(df, dic, by = "word")
df <- df %>% mutate(polarity = ifelse(is.na(polarity), 0, polarity))
score_df <- df %>% group_by(sentence) %>% summarise(score = sum(polarity))


### 댓글 감정 분석하기 ###
## 데이터 불러와서 전처리하기 ##
library(dplyr)
library(readr)
raw_news_comment <- read_csv("news_comment_parasite.csv")

install.packages("textclean")
library(textclean)
library(stringr)
news_comment <- raw_news_comment %>% mutate(id = row_number(), reply = str_squish(replace_html(reply))) %>% relocate(id, .before = reg_time)
glimpse(news_comment)

## 단어 기준 토큰화 및 감정 점수 부여하기 ##
library(tidytext)
word_comment <- news_comment %>% unnest_tokens(input = reply, output = word, token = "words", drop = F)
word_comment <- left_join(word_comment, dic, by = "word") %>% mutate(polarity = ifelse(is.na(polarity), 0, polarity))

## 감정 분류 및 막대 그래프 그리기 ##
word_comment <- word_comment %>% mutate(sentiment = ifelse(polarity == 2, "pos", ifelse(polarity == -2, "neg", "neu")))
word_comment %>% count(sentiment)

top10_sentiment <- word_comment %>% filter(sentiment != "neu") %>% count(sentiment, word) %>% group_by(sentiment) %>% slice_max(n, n = 10)
library(ggplot2)
ggplot(top10_sentiment, aes(reorder_within(word, n, sentiment), n, fill = sentiment)) + geom_bar(stat = "identity") + coord_flip() + facet_wrap(~sentiment, scales = "free") + scale_x_reordered() + labs(x = NULL) + geom_text(aes(label = n))

## 댓글별 감정 점수 구하기 ##
score_comment <- word_comment %>% group_by(id, reply) %>% summarise(score = sum(polarity)) %>% ungroup()
score_comment %>% arrange(-score) %>% head(10)
score_comment %>% arrange(score) %>% head(10)

score_comment %>% count(score)
score_comment <- score_comment %>% mutate(sentiment = ifelse(score >= 1, "pos", ifelse(score <= -1, "neg", "neu")))
score_comment %>% count(sentiment)