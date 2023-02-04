library(readr)
library(ggplot2)
library(lubridate)
library(reshape2)
library(dplyr)
library(stringr)
library(rtweet)
library(tidyr)
#set up API
auth <- rtweet_app()


# get timeline tweets
timeline <- get_timelines(c("NASA"), n = 5000, token = auth) #we will collect the recent 50 tweets from each of the three accounts, respectively. 

#partytweets <- read.csv("https://curiositybits.cc/files/gop_thedemocrats_timeline.csv")

#standardize timestamps
timeline$created_at <- ymd_hms(timeline$created_at) 
timeline$created_at <- with_tz(timeline$created_at,"America/New_York")
timeline$created_date <- as.Date(timeline$created_at)

timeline$date_label <- as.factor(timeline$created_date)
timeline$lang <- as.factor(timeline$lang)

##create daily count
daily_count <- timeline %>% 
  group_by(date_label, lang) %>% 
  summarise(avg_rt = mean(retweet_count),
            avg_fav = mean(favorite_count),
            tweet_count = length(unique(id_str))) 

daily_count <- daily_count %>% pivot_longer(cols = -c(date_label, lang), names_to = "variable", values_to = "value")

## visualize daily count 
daily_count$date_label <- as.Date(daily_count$date_label) ## in order for the dates to be plotted, date_label must be converted to Date

ggplot(data = daily_count[daily_count$variable=="tweet_count",], aes(x = date_label, y = value, group = lang)) +
  geom_line(size = 2.9, alpha = 1.7, aes(color = lang)) +
  geom_point(size = 1) +
  ylim(0, NA) +
  theme(legend.title=element_blank(), axis.title.x = element_blank()) +
  ylab("xxxx") + 
  ggtitle("xxx")


### TRY INTERACTIVE PLOTTING
library(highcharter)
title <- paste0("# of tweets ", Sys.Date())
highchart() %>%
  hc_add_series(daily_count[daily_count$variable=="tweet_count",],"line", hcaes(x = date_label, y = value,group=lang)) %>%
  hc_xAxis(type = "datetime")

# go beyond Twitter. Lets work on Facebook and Instagram data

## Challenge 1 

## Create a trend plot to show daily average likes for the Instagram account by Type. Add 'Average likes' as Y axis title and add "Instagram popularity" as plot title

instagram_posts <- read.csv("https://curiositybits.cc/files/umass-instagram.csv")

instagram_posts$date_label <- as.factor(instagram_posts$Post.Created.Date)

##create daily count
instagram_posts$Type <- as.factor(instagram_posts$Type)

daily_count <- xxxx %>% 
  group_by(xxx, xxx) %>% 
  summarise(avg_like = mean(xxx),
            avg_comments = mean(xxxx)) 

daily_count <- daily_count %>% pivot_longer(cols = -c(date_label, lang), names_to = "variable", values_to = "value")

## visualize daily count 
daily_count$date_label <- as.Date(daily_count$date_label) ## in order for the dates to be plotted, date_label must be converted to Date

ggplot(data = daily_count[daily_count$variable=="xxxx",], aes(x = date_label, y = value, group = xxxx)) +
  geom_line(size = 2.9, alpha = 1.7, aes(color = xxxx)) +
  geom_point(size = 1) +
  ylim(0, NA) +
  theme(legend.title=element_blank(), axis.title.x = element_blank()) +
  ylab("xxxx") + 
  ggtitle("xxxxx")

## Challenge 2

## Create a trend plot to show daily comments count for the Facebook page Add 'Average comments' as Y axis title and add "Facebook popularity" as plot title

fb_posts <- read.csv("https://curiositybits.cc/files/espn-fb.csv")

fb_posts$date_label <- as.factor(fb_posts$Post.Created.Date)

daily_count <- fb_posts %>% 
  group_by(Page.Name, Post.Created.Date) %>% 
  summarise(avg_like = mean(Likes),
            avg_comments = mean(Comments)) %>% melt

## visualize daily count 
daily_count$Post.Created.Date <- as.Date(daily_count$Post.Created.Date) ## in order for the dates to be plotted, date_label must be converted to Date

ggplot(data = daily_count[daily_count$variable=="avg_comments",], aes(x = Post.Created.Date, y = value)) +
  geom_line(size = 2.9, alpha = 1.7, color = "blue") +
  geom_point(size = 1) +
  ylim(0, NA) +
  theme(legend.title=element_blank(), axis.title.x = element_blank()) +
  ylab("Average Comments") + 
  ggtitle("Facebook Popularity")



