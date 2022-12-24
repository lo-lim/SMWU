crime <- USArrests
library(tibble)
crime <- rownames_to_column(crime, var = "state")
crime$state <- tolower(crime$state)

install.packages("maps")
library(maps)

library(ggplot2)
states_map <- map_data("state")

install.packages("mapproj")
library(mapproj)
install.packages("ggiraphExtra")
library(ggiraphExtra)
ggChoropleth(data = crime, aes(fill = Assault, map_id = state), map = states_map)
ggChoropleth(data = crime, aes(fill = Assault, map_id = state), map = states_map, interactive = T)

install.packages("kormaps2014")
install.packages("stringi")
library(stringi)
install.packages("devtools")
library(devtools)
devtools::install_github("cardiomoon/kormaps2014")
library(kormaps2014)

str(korpop1)
korpop1 <- korpop1
library(dplyr)
korpop1 <- rename(korpop1, pop = 총인구_명, name = 행정구역별_읍면동)
korpop1$name <- iconv(korpop1$name, "UTF-8","CP949")
ggChoropleth(data = korpop1, aes(fill = pop, map_id = code, tooltip = name), map = kormap1, interactive = T)

new_tbc <- tbc
new_tbc$name <- iconv(new_tbc$name, "UTF-8", "CP949")
new_tbc$name1 <- iconv(new_tbc$name1, "UTF-8", "CP949")
ggChoropleth(data = new_tbc, aes(fill = NewPts, map_id = code, tooltip = name), map = kormap1, interactive = T)

new_tbc_2002 <- new_tbc %>% filter(year == 2002)
ggChoropleth(data = new_tbc_2002, aes(fill = NewPts, map_id = code, tooltip = name1), map = kormap1, interactive = T)

install.packages("plotly")
library(plotly)
library(ggplot2)

p1 <- ggplot(data = mpg, aes(displ, highway, col = drv)) + geom_point()
ggplotly(p1)

p2 <- ggplot(data = mpg, aes(class, fill = class)) + geom_bar() + coord_flip()
ggplotly(p2)

p3 <- ggplot(data = mpg, aes(class, fill = fuel)) + geom_bar(position = "dodge")
ggplotly(p3)

head(diamonds)
str(diamonds)

p4 <- ggplot(data = diamonds, aes(cut, fill = clarity)) + geom_bar(position = "dodge")
ggplotly(p4)

p5 <- ggplot(data = diamonds, aes(cut, fill = color)) + geom_bar(position = "dodge")
ggplotly(p5)

install.packages("dygraphs")
library(dygraphs)
library(xts)
eco <- xts(economics$unemploy, order.by = economics$date)
dygraph(eco) %>% dyRangeSelector()

eco_a <- xts(corona19$total_cases, order.by = corona19$date)
eco_b <- xts(corona19$total_vaccinations/100, order.by = corona19$date)
eco_c <- cbind(eco_a, eco_b)
colnames(eco_c) <- c("total_cases", "total_vaccinations")
dygraph(eco_c) %>% dyRangeSelector()
