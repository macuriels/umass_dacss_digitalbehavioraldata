## This is a group challenge. Use the tutorial (https://weiaiwayne.github.io/teaching_dacss/sentiment_analysis_practice.html#step-2-clean-timestamps) for demo codes 

## Task 1: all XXX parts in the code below need to be edited/replaced to make the code work for the new data
## Task 2: If you see ## (PLEASE ANNOTATE THIS CODE) after a line of code, please write a comment there explaining what the line of code does
## Task 3: Produce a highcharter plot (line ) showing different sentiments over time by three distinct cities. Save a screenshot for submission
## Task 4: Produce a ggplot2 plot showing top sentiment words by sentiment types (line ). Screen capture it for submission

library(ggplot2)
library(lubridate)
library(reshape2)
library(dplyr)
library(syuzhet) 
library(stringr)
library(tidyr)

reviews <- read.csv("https://curiositybits.cc/files/airbnb_reviews_2018_sample.csv")

reviews$date <- ymd(reviews$date) ## function from the lubridate package to render a usable date format

airbnb_sentiment <- get_nrc_sentiment(reviews$comments)  ## function from the Syuzhet package that implements Saif Mohammad’s NRC Emotion lexicon to yield sentiments in a column
airbnb_sentiment <- cbind(reviews, airbnb_sentiment)    ## joins the two previously generated dataframes into one

aggregated <- airbnb_sentiment %>% ## code below is used to calculate averages for all sentiments, by city and by date
  group_by(city, date) %>% 
  summarise(anger = mean(anger), 
            anticipation = mean(anticipation), 
            disgust = mean(disgust), 
            fear = mean(fear), 
            joy = mean(joy), 
            sadness = mean(sadness), 
            surprise = mean(surprise), 
            trust = mean(trust),
            negative = mean(negative),
            positive = mean(positive)) 

aggregated <- aggregated %>% pivot_longer(cols = -c(city, date), names_to = "variable", values_to = "value")

#plot the data
aggregated$date <- as.Date(aggregated$date)
aggregated$city <- as.factor(aggregated$city)

library(highcharter)
title <- paste0("sentiment scores over time", Sys.Date())
highchart() %>%
  hc_add_series(aggregated[aggregated$variable=="negative",], "line", hcaes(x=date, y=value , group=city)) %>%
  hc_xAxis(type = "datetime")

library(tidytext)
library(textdata)
library(tidyr)

comment_clean <-  reviews %>%
  dplyr::select(comments) %>%
  unnest_tokens(word, comments)

sentiment_word_counts <- comment_clean %>%
  inner_join(get_sentiments("nrc")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

### visualize key sentimental terms
sentiment_word_counts %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(title = "Sentiment terms",
       y = "Contribution to sentiment",
       x = NULL) +
  coord_flip()
