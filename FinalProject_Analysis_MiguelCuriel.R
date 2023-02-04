# SET UP
library(shiny) #Shiny app
library(gtrendsR) #Google trends
library(rtweet) #Twitter data
library(readr) #CSV export
library(tidyverse) #essential data wrangling and visualization
library(spData) #alternative map
library(tmap) #alternative map
library(leaflet) #main map
library(quanteda) #text analysis
library(quanteda.textstats) #text analysis
library(quanteda.textplots) #text analysis
library(plotly) #dynamic visualizations
# 
# library(rCharts)
# library(dplyr)
# library(lubridate)
# library(highcharter)

# TWITTER
## download data
tweets <- search_tweets('#netflix', n = 18000)

## export tweets to CSV
write_csv(tweets, 'tweets.csv')

## extract geocodes from tweets
geocodes <- lat_lng(tweets)

## omit null geocodes
geocodes <- geocodes[!is.na(geocodes$lat), ]

## export geocodes to CSV
write_csv(geocodes, 'geocodes.csv')

# GOOGLE TRENDS
## download data
trends_netflix <- gtrends(keyword='netflix', time='2022-10-01 2022-12-07')
trends_disney <- gtrends(keyword='disney plus', time='2022-10-01 2022-12-07')
trends_hulu <- gtrends(keyword='hulu', time='2022-10-01 2022-12-07')
trends_amazon <- gtrends(keyword='prime video', time='2022-10-01 2022-12-07')
trends_hbo <- gtrends(keyword='hbo max', time='2022-10-01 2022-12-07')

## join dataframes
trends <- rbind(trends_netflix$interest_over_time
                ,trends_disney$interest_over_time
                ,trends_hulu$interest_over_time
                ,trends_amazon$interest_over_time
                ,trends_hbo$interest_over_time)

trends$date <- as.Date(trends$date)
trends$keyword <- as.factor(trends$keyword)

## export trends to CSV
write_csv(trends, 'trends.csv')

## create separate dataframe only with related queries
queries <- trends_netflix$related_queries

## export related queries to CSV
write_csv(queries, 'queries.csv')

## line plot using highchart (better for shiny)
highchart() %>% 
  hc_add_series(data = trends[trends$keyword=='hulu',], 'line', hcaes(x=date, y=hits, group=keyword)) %>%
  hc_xAxis(type = 'datetime')

## bar plot
trends_netflix$related_queries %>%
  filter(related_queries=='top') %>%
  mutate(value=factor(value,levels=rev(as.character(value))),
         subject=as.numeric(subject)) %>%
  top_n(10, value) %>%
  ggplot(aes(x=value, y=subject, fill="red")) +
  geom_bar(stat='identity',show.legend = F) +
  coord_flip() + labs(title="Queries most related with 'Netflix'")



## pivot to wider dataframe
trends <- trends %>% 
  select(date, keyword, hits) %>% 
  pivot_wider(names_from=keyword, values_from=hits) %>% 
  rename(disney='disney plus', amazon='prime video', hbo='hbo max')
  
## export trends to CSV
write_csv(trends, 'trends2.csv')

## line plot using plotly
trends %>%
  plot_ly(x=~date, y=~netflix, name='Netflix', type='scatter', mode='lines') %>% 
  add_trace(y=~hulu, name='Hulu', type='scatter', mode='lines') %>% 
  add_trace(y=~disney, name='Disney+', type='scatter', mode='lines') %>% 
  add_trace(y=~amazon, name='Prime Video', type='scatter', mode='lines') %>% 
  add_trace(y=~hbo, name='HBO Max', type='scatter', mode='lines')



