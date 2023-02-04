# installing necessary packages
library(ggplot2)
library(lubridate)
library(reshape2)
library(dplyr)
library(syuzhet) 
library(stringr)
library(tidyr)
library(rtweet)
library(readr)
library(highcharter)


# Task 1: Collect timeline tweets from a Twitter account 
# set n = 1000. It's okay if the final data frame contains fewer than 1,000 tweets
### Twitter authentification
### auth <- rtweet_app()
### alternative setup 
auth <- auth_setup_default() 
mytoken <- create_token(
  app = "R_Workshop_DB",
  consumer_key = "4EL1tCE2DG4OdtLrynOGnWsHi",
  consumer_secret = "57Urg78Zkpoqj4M6ZPL8TOXp7X4o0IM4Thh2FzmUGrm0TmgviD",
  access_token = "17917334-QzAR7yu42izruhOLsQEzVbHOVwXYHj0BrhMkqhJne",
  access_secret = "fvNA7z3Sb1nVfmqCIEJvDxkIWyvGlkbe6xXgscnXFlvzj") 
### collect timeline
elon_musk_timeline <- get_timeline("elonmusk", n = 1000, token = auth) 


# Task 2: Use practice scripts to create a ggplot2 plot showing the average daily retweet count for the Twitter account
# Change figure title to “Daily retweet count by @screenname” 
### create separate dataframe with necessary data transformations
daily_retweet_count <- elon_musk_timeline %>% 
  select(created_at, retweet_count) %>%
  mutate(created_at = as.Date(created_at)) %>% 
  group_by(created_at) %>%
  summarise(retweet_count = mean(retweet_count))
### plot above dataframe
ggplot(data = daily_retweet_count, aes(x = created_at, y = retweet_count)) +
  geom_line(size = 2.9, alpha = 1.7, color = "blue") +
  geom_point(size = 1) +
  ylim(0, NA) +
  theme(legend.title=element_blank(), axis.title.x = element_blank()) +
  ylab("Sum of retweets") + 
  ggtitle("Daily retweet count by @elonmusk")


# Task 3: Apply the NRC sentiment dictionary to the tweets and calculate POSITIVE and Negative sentiment scores for each tweet
# Create a highcharter plot showing POSITIVE and Negative scores over time
### run single line of code to get sentiment (since this function takes a lot to run)
elon_musk_sentiment_raw <- get_nrc_sentiment(elon_musk_timeline$full_text)
### then, perform necessary transformations
elon_musk_sentiment <- cbind(elon_musk_timeline, elon_musk_sentiment_raw) %>%
  select(created_at, positive, negative) %>%
  mutate(created_at = as.Date(created_at)) %>% 
  group_by(created_at) %>%
  summarise(positive = mean(positive), negative = mean(negative)) %>%
  pivot_longer(cols = -c(created_at), names_to = "variable", values_to= "value")
### and create highcharter plot
title <- paste0("@elonmusk positive and negative scores over time", Sys.Date())
highchart() %>%
  hc_add_series(elon_musk_sentiment, "line", hcaes(x=created_at, y=value , group=variable)) %>%
  hc_xAxis(type = "datetime")


# Task 4: Sort tweets by POSITIVE and Negative scores, respectively. 
# Copy and paste the top five most positive and most negative tweets
# In addition, explain briefly why these tweets are rated the most positive and negative, respectively. 
# Also, explain if you think the top sentiment scores reflect the true sentiments expressed in the tweets. 
### script to view top 5 comments for both negative and positive
elon_musk_sorted <- cbind(elon_musk_timeline, elon_musk_sentiment_raw) %>%
  select(full_text, positive, negative) %>%
  pivot_longer(cols = -c(full_text), names_to = "variable", values_to= "value") %>%
  arrange(desc(value)) %>%
  group_by(variable) %>%
  slice(1:5)