##installing packages we will use

install.packages("tidyverse")
library(tidyverse)
install.packages("skimr")
library(skimr)
install.packages("janitor")
library(janitor)

##downloading and looking at the data

starbucks<-starbucks_drinkMenu_expanded
colnames(starbucks)

##clean and rename the columns to make them consistent 

starbucks<-starbucks %>% clean_names()

starbucks<-starbucks %>% rename(total_fat=total_fat_g, total_carbs=total_carbohydrates_g, caffeine=caffeine_mg, protein=protein_g, sugars=sugars_g)
colnames(starbucks)

##using ggplot to show calories vs. caffeine based on beverage category

ggplot(data=starbucks, aes(x=calories, y=caffeine, color=beverage_category))+geom_point()

##showing correlation between calories and sugar

ggplot(data=starbucks, aes(x=calories, y=sugars))+geom_point()+geom_smooth()

##adding titles and axis lables 

ggplot(data=starbucks, aes(x=caffeine, y=sugars, color=beverage_category))+geom_point()+labs(title="sugars vs caffeine",subtitle="comparison", x= "caffeine in mg",y="sugar in g",color="beverage_category")
