# install necessary packages
library(readr)
library(dplyr)
library(quanteda)
library(quanteda.textstats)
library(quanteda.textplots)
library(ggplot2)
library(DT)

# step 1: load data
airbnb_reviews <- read_csv("https://curiositybits.cc/files/airbnb_reviews_2018_sample.csv")

# step 2: create corpus and show 10th document
corpus1 <- corpus(airbnb_reviews, docid_field = "id", text_field = "comments") 
as.character(corpus1)[10]

# step 3: tokenize 10th document while removing punctuation, numbers, symbols, and urls
tokens(corpus1[10], remove_punct=TRUE, remove_numbers=TRUE, remove_symbols=TRUE, remove_url=TRUE)

# step 4: tokenize the corpus, the create a Doc-Ft Matrix, and show first 5 words in the first 5 documents from the DFM 
airbnb_dfm <- tokens(corpus1, remove_punct=TRUE, remove_numbers=TRUE, remove_symbols=TRUE, remove_url=TRUE) %>%
  tokens_remove(stopwords("en")) %>%
  dfm()
airbnb_dfm[1:5,1:5]