# install necessary packages
library(readr)
library(dplyr)
library(quanteda)
library(quanteda.textstats)
library(quanteda.textplots)
library(seededlda)
library(ggplot2)
library(DT)
library(rtweet)

# Twitter connection using alt method
# auth <- auth_setup_default() 
mytoken <- create_token(
  app = "R_Workshop_DB",
  consumer_key = "4EL1tCE2DG4OdtLrynOGnWsHi",
  consumer_secret = "57Urg78Zkpoqj4M6ZPL8TOXp7X4o0IM4Thh2FzmUGrm0TmgviD",
  access_token = "17917334-QzAR7yu42izruhOLsQEzVbHOVwXYHj0BrhMkqhJne",
  access_secret = "fvNA7z3Sb1nVfmqCIEJvDxkIWyvGlkbe6xXgscnXFlvzj") 

# Task 1: Collect tweets based on a hashtag of your choice 
# (set n = 2000. It's okay if the final data frame contains fewer than 1,000 tweets). 
hashtag <- search_tweets("#kanyewest", n = 2000, include_rts = FALSE)

# Task 2: Follow the tutorial to show the top words ranked by TF-IDF.
corpus1 <- corpus(hashtag, docid_field = "id", text_field = "text")
data_tokens <- tokens(corpus1)

hashtag_dfm <- tokens(corpus1, remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove_url=TRUE) %>%  
  tokens_remove(stopwords("en")) %>%
  dfm()

topfeatures(hashtag_dfm) ## this shows top words by basic word count

# Task 3: Based on the top words ranked by TF-IDF, what can you learn about the general themes in the collected tweets? 
## Purely from the TF-IDF, I can infer the hasthag #kanyewest seems to be involved in US sociopolitics (#usa, #news, #court).
## There also seems to be a relationship with other celebrities and social themes/organizations (#steve, #harvey, #movie, #nfl).

# Task 4: Follow the tutorial to create a semantic network based on hashtag co-occurrence. 
# The semantic network should include top 50 hashtags and relationships among the 50 hashtags. 
tag_dfm <- dfm_select(hashtag_dfm, pattern = "#*")
toptag <- names(topfeatures(tag_dfm, 50)) # get top 50 results
tag_fcm <- fcm(tag_dfm)
topgat_fcm <- fcm_select(tag_fcm, pattern = toptag)
textplot_network(topgat_fcm, min_freq = 0.1, edge_alpha = 0.5, edge_size = 1, edge_color = "orange")

#Task 5: Please try to interpret the semantic network. 
# What does it reveal about the general themes in the collected tweets? 
## The hashtag #kanywest seems to be associated to three clusters: 
## One regarding the migration/humanitarian crisis in Central America, 
## the other regarding the artist’s antisemitic comment, 
## and the last regarding his association to other pop-culture celebrities and organizations.

# Task 6: Please create topic models based on the collected tweets. 
# Try 3 different versions of k. 
## k = 10
tmod_lda_k10 <- textmodel_lda(hashtag_dfm, k = 10) #Adjust k as needed
terms(tmod_lda_k10, 10) #Extract the 10 most important terms for each topic from the topic model 

## k = 20
tmod_lda_k20 <- textmodel_lda(hashtag_dfm, k = 20) #Adjust k as needed
terms(tmod_lda_k10, 10) #Extract the 10 most important terms for each topic from the topic model 

## k = 25
tmod_lda_k25 <- textmodel_lda(hashtag_dfm, k = 25) #Adjust k as needed
terms(tmod_lda_k25, 10) #Extract the 10 most important terms for each topic from the topic model 

# Task 7: From the previous step, you will end up with three different topic models (based on the 3 different k),
# pick one of the topic models, inspect the result, and explain why the model is a fit or a misfit.
## Using k = 10 as the point of reference, this model seems to be a misfit. 
## While most groupings make sense, not all of them provide value as the categories are too broad or are missing context for them to be properly understood.
## For example, while words like "Belize", "latinos" and "maya" are grouped together, make sense, and can be analyzed,
## there is another group which seems to correspond to monosyllabic Spanish words ("de", "la", "en", "que"), hence not providing much value or context.
## Or while, on one hand, there are a couple of groupings that refer to Kanye's antisemitic comments,
## there are also a couple that relate the artist to other public figures (such as Elon Musk or Steve Harvey).