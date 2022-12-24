library(readr)
movie <- read_csv("movie.csv", col_names = T, locale=locale('ko', encoding='euc-kr'))
#문제 1#
library(dplyr)
movie%>% group_by(Certificate) %>% summarise(count=n()) %>% arrange(-count)

#문제 2#
hist(movie$Meta_score, breaks = seq(0,100,5))

#문제 3#
movie_2019 <- movie%>% filter(Released_Year==2019)
table(movie_2019$Meta_score>90)

#문제 4#
movie <- movie %>% mutate(Length=case_when(Runtime<80~"short", Runtime<120~"proper", Runtime<150~"long", Runtime>=150~"full"))
movie %>% group_by(Length) %>% summarise(n())

#문제 5#
movie$Gross <- ifelse(is.na(movie$Gross), 100*movie$No_of_Votes, movie$Gross)
mean(movie$Gross)

#문제 6#
movie_1%>% filter(IMDB_Rating>= quantile(IMDB_Rating, probs=c(0.95)) & Meta_score>= quantile(Meta_score, probs=c(0.95)))

movie_1 <- movie %>% select(IMDB_Rating, Meta_score, Series_Title) %>% filter(!is.na(Meta_score))

movie_1 <- movie %>% select(IMDB_Rating, Meta_score, Series_Title) %>% filter(Meta_score, na.rm=T)

#문제 7#
movie %>% group_by(Star1) %>% summarise(count=n()) %>% arrange(-count)

