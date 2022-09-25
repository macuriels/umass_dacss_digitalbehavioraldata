#load libraries. Make sure the libraries are installed
library(rtweet)

auth <- auth_setup_default() 

mytoken <- create_token(
  
  app = "R_Workshop_DB",
  
  consumer_key = "4EL1tCE2DG4OdtLrynOGnWsHi",
  
  consumer_secret = "57Urg78Zkpoqj4M6ZPL8TOXp7X4o0IM4Thh2FzmUGrm0TmgviD",
  
  access_token = "17917334-QzAR7yu42izruhOLsQEzVbHOVwXYHj0BrhMkqhJne",
  
  access_secret = "fvNA7z3Sb1nVfmqCIEJvDxkIWyvGlkbe6xXgscnXFlvzj") 

###### data wrangling demo 
timeline1 <- get_timelines("POTUS", n = 200, token = auth) #get the recent 200 tweets from an account

popular_tweets <- timeline1[timeline1$retweet_count>20,]

popular_tweets <- timeline1[timeline1$retweet_count>20, c("text","retweet_count","lang", "created_at")] 

save_as_csv(popular_tweets, "popular_tweets.csv") #this is for saving tweets collected through the library rtweet.
#for saving regular data frames in R, use the following 
write.csv(popular_tweets,"popular_tweets.csv") 

## Find tweets in a dataframe by a keyword
library(dplyr)

timeline1$text <- tolower(timeline1$text) # convert all text to lower-case

keyword_df <- timeline1 %>% # filter tweets by a keyword
  filter(grepl("peace",text))

### Group 1: 
#Challenge 1: Get 200 followers from a Twitter account of your group's choice. Subset the dataframe to include followers who are followed by at least 1000 others. Save the output as followers.csv
auth <- rtweet_app()
followers <- get_followers("elonmusk", n = 200, token = auth) #get a user's followers
bio <-  lookup_users(followers$from_id, token=auth) 
bio <- bio[,] 
library(readr)
write_csv(bio,"bio.csv") 
# save_as_csv(XXXX, "XXXX.csv")

### Group 2: 
#Challenge 2: Get 100 friends from a Twitter account of your group's choice. Subset the dataframe to include friends who are VERIFIED. Save the output as friends.csv
auth <- rtweet_app()
friends <- get_friends("", token = auth) #get a user's followers
bio <-  lookup_users(friends$to_id, token=auth) 
bio <- bio[,] 
save_as_csv(XXXX, "XXXX.csv")

### Group 3: 
#Challenge 3: Get 200 followers from a Twitter account of your group's choice. Subset the dataframe to include followers whose Twitter bios contain a specific keyword. Save the output as followers_keywords.csv
auth <- rtweet_app()
followers <- get_followers("", token = auth) #get a user's followers
bio <-  lookup_users(followers$from_id, token=auth) 
bio$description <- tolower(bio$description) # convert all text to lower-case

keyword_df <- xxxx %>% # filter tweets by a keyword
  filter(grepl("xxx",xxx))

save_as_csv(XXXX, "XXXX.csv")

### Group 4: 
#Challenge 4: Get 200 followers from a Twitter account of your group's choice. Subset the dataframe to include followers whose entries on the location field match a specific term. Save the output as followers_loc.csv
auth <- rtweet_app()
followers <- get_followers("", token = auth) #get a user's followers
bio <-  lookup_users(followers$from_id, token=auth) 
bio$location <- tolower(bio$location) # convert all text to lower-case

keyword_df <- xxxx %>% # filter tweets by a keyword
  filter(grepl("xxx",xxx))

save_as_csv(XXXX, "XXXX.csv")

### Group 5: 
#Challenge 5: Get 200 followers from a Twitter account of your group's choice. Subset the dataframe to include only five columns: screen_name, description, location, followers_count, friends_count. Save the output as followers_select.csv
auth <- rtweet_app()
followers <- get_followers("", token = auth) #get a user's followers
bio <-  lookup_users(followers$from_id, token=auth) 
bio <- bio[,c("xx","xxx")]
save_as_csv(XXXX, "XXXX.csv")
