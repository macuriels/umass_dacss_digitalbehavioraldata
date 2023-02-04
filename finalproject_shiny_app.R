#THIS IS A DEMO APP FOR SHOWING SENTIMENTS AND MAP IN TWEETS

library(shiny)
# library(rCharts)
library(lubridate)
library(highcharter)
library(leaflet)
library(quanteda)
library(quanteda.textstats)
library(quanteda.textplots)

# UI
ui <- fluidPage(
  
  # Application title
  titlePanel("Your app title"),
  
  p(
    class = "text-muted",
    paste("Demo: you can enter text here."
    )
  ),
    
  
  sidebarLayout(
    sidebarPanel(        
      helpText(h5("based on sentiment type", style = "font-family: 'arial'; font-si12pt")),
      
      sliderInput("slider1", h3("min. retweet count for wordcloud"),
                  min = 0, max = 100, value = 1),
      
      sliderInput("slider2", h3("min. retweet count for geo-mapping"),
                  min = 0, max = 100, value = 1),
      
      p(
        class = "text-muted",
        paste("Demo: you can enter text here."
        )
      )
      
      ),
    
    
    mainPanel(
      plotOutput("wordcloud"),
      leafletOutput("mymap"),
      p(class = "text-muted",paste("Demo: you can enter text here.")
      )
    )
  )
)

# SERVER 
server <- function(input, output) {

  geocodes <- read.csv("geocodes.csv", header = TRUE)
  geocodes$text <- as.character(geocodes$text)
  
  tweets <- read.csv("tweets.csv", header = TRUE)
  tweets$text <- as.character(tweets$text)
  
  output$wordcloud <- renderPlot({
    dfm <- dfm(tweets[tweets$retweet_count >= input$slider1,]$text, remove = c(stopwords("english"), remove_numbers = TRUE, remove_symbols = TRUE, remove_punct = TRUE))
    dfm <- dfm_select(dfm, pattern = ("#*|@*"))
    set.seed(100)
    textplot_wordcloud(dfm, min_size = 1.5, min_count = 10, max_words = 100,color = rev(RColorBrewer::brewer.pal(10, "RdBu")))
  })
  
  output$mymap <- renderLeaflet({
    
    usericon <- makeIcon(
      iconUrl = geocodes$profile_image_url,
      iconWidth = 15, iconHeight = 15
    )
    
    
    leaflet(data = geocodes[geocodes$retweet_count >= input$slider2,]) %>% 
      addTiles() %>%
      setView(lng = -98.35, lat = 39.50, zoom = 2) %>% 
      addMarkers(lng = ~lng, lat = ~lat,popup = ~ as.character(text),icon = usericon) %>% 
      addProviderTiles("Stamen.TonerLite") %>%  #more layers:http://leaflet-extras.github.io/leaflet-providers/preview/
      addCircleMarkers(
        stroke = FALSE, fillOpacity = 0.5)
  })
    
}

# Run the application 
shinyApp(ui = ui, server = server)

