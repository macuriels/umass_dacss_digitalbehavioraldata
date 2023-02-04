# install necessary packages
library(readr)
library(dplyr)
library(quanteda)
library(quanteda.textstats)
library(quanteda.textplots)
library(seededlda)
library(ggplot2)
library(DT)

# Follow the tutorial to create a DFM based on the UMas Instagram account's posts. 
# Show top words ranked by TF-IDF. 
# Screen capture the output and upload in Google / Spire. 
instagram <- read_csv("https://curiositybits.cc/files/umass-instagram.csv")
corpus1 <- corpus(instagram, docid_field = "URL", text_field = "Description")  ## use the 'status_id' column as unique identifiers of documents 
data_tokens <- tokens(corpus1)

instagram_dfm <- tokens(corpus1, remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove_url=TRUE) %>%  
  tokens_remove(stopwords("en")) %>%
  dfm()

topfeatures(instagram_dfm) ## this shows top words by basic word count

# Create a LDA model based on the Instagram posts. Set the number of topics to 25. 
# Show top 10 terms from each topic and upload output screen captures in Google / Spire. 
tmod_lda <- textmodel_lda(instagram_dfm, k = 25) # Set k=10 and look for 20 topics in the dfm.

terms(tmod_lda, 10) #Extract the 10 most important terms for each topic from the topic model 