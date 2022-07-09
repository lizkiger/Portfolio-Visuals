install.packages("tidyverse")
library(tidyverse)
install.packages("here")
library(here)
install.packages("skimr")
library(skimr)
install.packages("janitor")
library(janitor)
library(lubridate)
install.packages("ggpubr")
library(ggpubr)
install.packages("ggrepel")
library(ggrepel)
##installing packages used for this project

##installing the datasets for daily activity, daily sleep and step hours and renaming each.

daily_activity <- read_csv("C:/Users/Liz Kiger/Desktop/Liz Data Study/Bellabeat/Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv")
daily_sleep <- read_csv("C:/Users/Liz Kiger/Desktop/Liz Data Study/Bellabeat/Fitabase Data 4.12.16-5.12.16/sleepDay_merged.csv")
hourly_steps <- read_csv("C:/Users/Liz Kiger/Desktop/Liz Data Study/Bellabeat/Fitabase Data 4.12.16-5.12.16/hourlySteps_merged.csv")

#preview and show summary of each column.
head(daily_activity)
str(daily_activity)
head(daily_sleep)
str(daily_sleep)
head(hourly_steps)
str(hourly_steps)

##we can also use skim without charts to give us some more information about the dataset.
skim_without_charts(daily_activity)
skim_without_charts(daily_sleep)
skim_without_charts(hourly_steps)

##let's find out how many unique users there are per dataframe and check for any duplicates.
n_unique(daily_activity$Id)
n_unique(daily_sleep$Id)
n_unique(hourly_steps$Id)

sum(duplicated(daily_activity))
sum(duplicated(daily_sleep))
sum(duplicated(hourly_steps))

##daily sleep showed duplicates so we will delete them.

daily_activity <- daily_activity %>%
  distinct() %>%
  drop_na()

daily_sleep <- daily_sleep %>%
  distinct() %>%
  drop_na()

hourly_steps <- hourly_steps %>%
  distinct() %>%
  drop_na()

##check one more time to make sure the duplicates were dropped.
sum(duplicated(daily_sleep))

##making sure to clean and rename columns so that they are in the same format since we will merge them later on.

clean_names(daily_activity)
daily_activity<- rename_with(daily_activity, tolower)
clean_names(daily_sleep)
daily_sleep <- rename_with(daily_sleep, tolower)
clean_names(hourly_steps)
hourly_steps <- rename_with(hourly_steps, tolower)

daily_activity <- daily_activity %>%
  rename(date = activitydate) %>%
  mutate(date = as_date(date, format = "%m/%d/%Y"))

daily_sleep <- daily_sleep %>%
  rename(date = sleepday) %>%
  mutate(date = as_date(date,format ="%m/%d/%Y %I:%M:%S %p" , tz=Sys.timezone()))

##check to make sure the data was cleaned
head(daily_activity)
head(daily_sleep)

##looking at the hourly_steps we saw that the activity hour was <chr> and we want to convert that to date-time.

hourly_steps<- hourly_steps %>% 
  rename(date_time = activityhour) %>% 
  mutate(date_time = as.POSIXct(date_time,format ="%m/%d/%Y %I:%M:%S %p" , tz=Sys.timezone()))
head(hourly_steps)

##we will merge the data sets together.  It looks like id and date is the primary key.

daily_activity_sleep <- merge(daily_activity, daily_sleep, by=c ("id", "date"))
glimpse(daily_activity_sleep)

##let's look at the type of users from our sample using https://www.10000steps.org.au/articles/counting-steps/
##this article categorizes users by sedentary, lightly active, fairly active and very active.

daily_average <- daily_activity_sleep %>%
  group_by(id) %>%
  summarise (mean_daily_steps = mean(totalsteps), mean_daily_calories = mean(calories), mean_daily_sleep = mean(totalminutesasleep))
head(daily_average)

##classify users by daily average steps.
user_type <- daily_average %>%
  mutate(user_type = case_when(
    mean_daily_steps < 5000 ~ "sedentary",
    mean_daily_steps >= 5000 & mean_daily_steps < 7499 ~ "lightly active", 
    mean_daily_steps >= 7500 & mean_daily_steps < 9999 ~ "fairly active", 
    mean_daily_steps >= 10000 ~ "very active"
  ))
head(user_type)

##we can show the number of users and the type of user using tally. 

user_type %>% group_by(user_type) %>% tally()

##for example we could just look at what percent of the sample group is a very active user compared to the rest.

total_users<- nrow(user_type)
very_active_user<-dplyr::filter(user_type, user_type %in% "very active")
total_very_active_user<-nrow(very_active_user)
percent_very_active<-(total_very_active_user/total_users)*100
##it looks like 20.8% of users fall under the very active user type(without rounding the percentage).

##we can also find all user type percentages here:

user_type_percent <- user_type %>%
  group_by(user_type) %>%
  summarise(total = n()) %>%
  mutate(totals = sum(total)) %>%
  group_by(user_type) %>%
  summarise(total_percent = total / totals) %>%
  mutate(labels = scales::percent(total_percent))
user_type_percent$user_type <- factor(user_type_percent$user_type , levels = c("very active", "fairly active", "lightly active", "sedentary"))
head(user_type_percent)

##let's see what days of the week users are more active and what days of the week users sleep more.  We will find out the average steps walked and minutes slept by weekday.

weekday_steps_sleep <- daily_activity_sleep %>%
mutate(weekday = weekdays(date))

weekday_steps_sleep$weekday <-ordered(weekday_steps_sleep$weekday, levels=c            
                                      ("Monday", "Tuesday", "Wednesday", "Thursday",
                                        "Friday", "Saturday", "Sunday"))

weekday_steps_sleep <-weekday_steps_sleep%>%
  group_by(weekday) %>%
  summarize (daily_steps = mean(totalsteps), daily_sleep = mean(totalminutesasleep))
head(weekday_steps_sleep)

##using ggplot to show daily steps and minutes asleep per weekday.  

ggarrange(
  ggplot(weekday_steps_sleep) +
    geom_col(aes(weekday, daily_steps), fill = "#006699") +
    geom_hline(yintercept = 7500) +
    labs(title = "Daily steps per weekday", x= "", y = "") +
    theme(axis.text.x = element_text(angle = 45,vjust = 0.5, hjust = 1)),
  ggplot(weekday_steps_sleep, aes(weekday, daily_sleep)) +
    geom_col(fill = "#85e0e0") +
    geom_hline(yintercept = 480) +
    labs(title = "Minutes asleep per weekday", x= "", y = "") +
    theme(axis.text.x = element_text(angle = 45,vjust = 0.5, hjust = 1))
)

##looking to see if there is a correlation between daily steps and daily sleep.  It does not look like it.

ggplot(daily_activity_sleep, aes(x=totalsteps, y=totalminutesasleep))+
  geom_jitter() +
  geom_smooth(color = "purple")

##in the 31 days that users tracked, let's see their usage rate.

daily_use <- daily_activity_sleep %>%
  group_by(id) %>%
  summarize(days_used=sum(n())) %>%
  mutate(usage = case_when(
    days_used >= 1 & days_used <= 10 ~ "low usage",
    days_used >= 11 & days_used <= 20 ~ "moderate usage", 
    days_used >= 21 & days_used <= 31 ~ "high usage", 
  ))
head(daily_use)

##we are now able to see usage based on how many days used