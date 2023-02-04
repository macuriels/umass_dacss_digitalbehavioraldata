## install necessary packages
library(shiny) #Shiny app
library(gtrendsR) #Google trends
library(rtweet) #Twitter data
library(readr) #CSV export
library(tidyverse) #essential data wrangling and visualization
library(leaflet) #world map
library(quanteda) #text analysis
library(quanteda.textstats) #text analysis
library(quanteda.textplots) #text analysis
library(highcharter) #dynamic visualizations

# UI
ui <- fluidPage(
  titlePanel("Netflix Trend Analysis - by Miguel Curiel for UMass Digital Behavioral Data, Fall 2022")
  ,tags$head(
    tags$meta(name="author", content="My Name")
    ,tags$meta(name="creation_date", content="21/08/2020"))
  ,p(class = 'text-muted'
     ,paste('This dashboard is created to explore digital trends related to Netflix. 
            Click on each tab to explore insights obtained from Google (timeframe for data download: Oct/01/2022 - Dec/07/2022) 
            and Twitter (timeframe for data download: Dec/04/2022 - Dec/07/2022)'))
  ,tabsetPanel(type = 'tabs'
               ,tabPanel("Google"
                         ,fluidRow(
                           column(width=2, checkboxGroupInput(
                               'streaming'
                               ,label = helpText(h5('Choose streaming service for comparative line plot'))
                               ,choices = list('netflix', 'disney plus', 'hulu', 'hbo max', 'prime video')
                               ,selected = 'netflix'
                               ))
                           ,column('Interest Over Time', width=5, highchartOutput('lineplot'))
                           ,column('Associated Google Searches', width=4, plotOutput('barplot')))
                         ,p('Key findings of Netflix on Google:')
                         ,tags$ul(
                           tags$li("There is a cyclical spike in interest in Netflix which occurs approximately every seven days, usually on Sundays. This could be used to define Sunday as the best day to release content."), 
                           tags$li("Netflix and HBO Max are usually the most popular streaming service at any given time, while Disney Plus is the least popular. This could be monitored constantly to understand how well Netflix is doing in comparison in terms of popularity."), 
                           tags$li("Creative horror series ('Dahmer - Monster' and 'Wednesday') are among the most popular search queries associated to Netflix. This could be used to determine what type of content is most popular for the general audience and double-down on such type of content."))
                         ,p('Limitations to keep in mind:')
                         ,tags$ul(
                           tags$li("Timeframe is relatively small - it is recommended to increase the sample size to gain a wider perspective of the trends."),
                           tags$li("Correlation is not causality - while it is tempting to state that Sunday is an ideal day to release new content, it would be better to repeat such analysis with more (possibly confounding) variables."),
                           tags$li("Only two metrics - while Google provides good metrics to determine a popular topics, other measurements (such as subscribers) should be taken into account before determining a streaming service is really the most popular"))
                         )
               ,tabPanel("Twitter"
                         ,fluidRow(
                           column('Tweet Map', width=6, leafletOutput('map'))
                           ,column('Hashtag Network', width=6, plotOutput('network'))
                           ,p('Key findings of Netflix on Twitter:')
                           ,tags$ul(
                             tags$li("There is a high concentration of tweets in the USA and in Europe. This could be used to determine where people are interacting the most with Netflix"), 
                             tags$li("Several of these tweets talk about Wednesday, the Addam's family spin-off This could be used to determine what type of content to create by location."),
                             tags$li("From the hashtag network, there are roughly four clusters: two of are in Arabic, one is about other popular brands (such as Nike and Apple), and the last is about pop culture (this is also the most tight-knit cluster and has topics such as FIFA and NFTs). 
                                     This could be used to understand what is being said about Netflix, reach more people and be a part of the broader conversation."))
                           ,p('Limitations to keep in mind:')
                           ,tags$ul(
                             tags$li("Twitter organizational restructuring - at the time of this analysis, Twitter is undergoing major structural changes (new CEO, new rules) which can impact what people express and the amount of data obtained"), 
                             tags$li("Geographical data scarcity - given that geographic data is scarce on Twitter, it is important to note that certain tweets may be excluded from the analysis"),
                             tags$li("Limited timeframe - given that it is complicated to extract data for wide timespans, findings should be understood within its own timeframe.")) 
                           ))
))

# SERVER 
server <- function(input, output) {

  geocodes <- read.csv('geocodes.csv', header = TRUE)
  geocodes$text <- as.character(geocodes$text)
  
  tweets <- read.csv('tweets.csv', header = TRUE)
  tweets$text <- as.character(tweets$text)
  
  trends <- read.csv('trends.csv', header = TRUE)
  trends$date <- as.Date(trends$date)
  trends$keyword <- as.factor(trends$keyword)
  
  queries <- read.csv('queries.csv', header = TRUE)
  
  output$lineplot <- renderHighchart({
    highchart() %>%
      hc_add_series(data = trends[trends$keyword %in% input$streaming,], 'line', hcaes(x=date, y=hits, group=keyword)) %>%
      hc_xAxis(type = 'datetime')
  })

  output$barplot <- renderPlot({
    queries %>%
      filter(related_queries=='top') %>%
      mutate(value=factor(value,levels=rev(as.character(value))),
             subject=as.numeric(subject)) %>%
      top_n(10, value) %>%
      ggplot(aes(x=value, y=subject)) +
      geom_bar(stat='identity', show.legend=F, fill='skyblue1') +
      coord_flip() +
      theme(axis.title.x=element_blank(), axis.title.y=element_blank())
  })
  
  output$network <-renderPlot({
    corpus1 <- corpus(tweets, docid_field = 'id_str', text_field = 'text') 
    
    tweets_dfm <- tokens(corpus1, remove_punct = TRUE, remove_numbers = TRUE, remove_url=TRUE) %>%  
      tokens_remove(stopwords('en')) %>%
      dfm()
    
    tag_dfm <- dfm_select(tweets_dfm, pattern = '#*')
    toptag <- names(topfeatures(tag_dfm, 100))
    tag_fcm <- fcm(tag_dfm)
    
    toptag_fcm <- fcm_select(tag_fcm, pattern = toptag)
    textplot_network(toptag_fcm, min_freq=0.1, edge_alpha=0.5, edge_size=1, edge_color='blue')
  })
  
  output$map <- renderLeaflet({
    leaflet(data = geocodes) %>% 
      addTiles() %>%
      setView(lng = -98.35, lat = 39.50, zoom = 3) %>%
      addMarkers(lng = ~lng, lat = ~lat, popup = ~ as.character(text)) %>% 
      addProviderTiles("OpenStreetMap.Mapnik") %>%
      addCircleMarkers(stroke = FALSE, fillOpacity = 0.5) %>% 
      addLegend(title="#netflix on Twitter", colors= c("blue"), labels=c("Tweets"))
  })
    
}

# RUN APP
shinyApp(ui=ui, server=server)
