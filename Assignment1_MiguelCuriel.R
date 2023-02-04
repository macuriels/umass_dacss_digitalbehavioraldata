#load libraries. Make sure the libraries are installed
library(rtweet)
library(dplyr)
library(readr)

#Twitter authentification
auth <- rtweet_app()

### alternative setup 
# auth <- auth_setup_default() 
# mytoken <- create_token(
#   app = "R_Workshop_DB",
#   consumer_key = "4EL1tCE2DG4OdtLrynOGnWsHi",
#   consumer_secret = "57Urg78Zkpoqj4M6ZPL8TOXp7X4o0IM4Thh2FzmUGrm0TmgviD",
#   access_token = "17917334-QzAR7yu42izruhOLsQEzVbHOVwXYHj0BrhMkqhJne",
#   access_secret = "fvNA7z3Sb1nVfmqCIEJvDxkIWyvGlkbe6xXgscnXFlvzj") 

#Task 1: Collect 500 tweets based on a hashtag/keyword of my choice (get popular instead of recent)
#name the data frame as populartweets and save as a CSV file using the filename populartweets.csv
populartweets <- search_tweets(q = "Paramore", n = 500, type = "popular", retryonratelimit = TRUE, token = auth) 
write_csv(populartweets, "populartweets.csv") 

#Task 2: Based on the 500 tweets, create another data frame that contains tweets that have been retweeted at least TWICE
#name the new data frame as retweetedtwice and save the dataframe as a CSV file (retweetedtwice.csv)
retweetedtwice <- subset(populartweets, populartweets$retweet_count >= 2)
write_csv(retweetedtwice, "retweetedtwice.csv") 

#Task 3: In your R script, add a comment section, write down the min and max value of retweet count of the 500 tweets
#and the timeframe of the 500 tweets
##MIN: 16
##MAX: 13533
##TIMEFRAME: 2022-09-20 10:18:51 to 2022-09-28 13:49:29



