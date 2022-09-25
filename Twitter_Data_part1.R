#load libraries. Make sure the libraries are installed

library(rtweet)
library(purrr)
library(readr)


## API
# or use app based authentication, run this code
# auth <- rtweet_app()
vignette('auth')

auth <- auth_setup_default() 

mytoken <- create_token(
  
  app = "R_Workshop_DB",
  
  consumer_key = "4EL1tCE2DG4OdtLrynOGnWsHi",
  
  consumer_secret = "57Urg78Zkpoqj4M6ZPL8TOXp7X4o0IM4Thh2FzmUGrm0TmgviD",
  
  access_token = "17917334-QzAR7yu42izruhOLsQEzVbHOVwXYHj0BrhMkqhJne",
  
  access_secret = "fvNA7z3Sb1nVfmqCIEJvDxkIWyvGlkbe6xXgscnXFlvzj") 

#now test if we can connect to the API by searching 100 recent tweets that contain a keyword of your interest

### Group 1: the search_tweets function. 
#Challenge 1: Get 1,000 popular original (retweets not included) tweets based on a keyword/hashtag of your group's choice. Set the Twitter rate limits to refresh every 15 minutes.

tweets1 <- search_tweets("#ukraine", n = 500,include_rts = FALSE,retryonratelimit = TRUE, token=auth) #Find 200 tweets (non-retweets) that contain the key term from Twitter Search API
?search_tweets() #find help document about the search_tweets() function
###
tweets1

### Group 2: the stream_tweets function. 
#Challenge 2:Pick a keyword/hashtag, stream for 20 seconds to get the latest tweets

tweets2 <- stream_tweets("#ukraine", timeout = 10) #keep streaming tweets for 10 seconds
?stream_tweets() #pull up help document on the function

### Group 3: the get_timelines function. 
#Challenge 3:Pick two Twitter accounts. Get 100 recent timeline tweets from each of the two accounts, respectively. 

timeline1 <- get_timelines("UMassDACSS", n = 200, token = auth) #get the recent 200 tweets from an account
timeline2 <- get_timelines(c("UMassDACSS", "UMassAmherst", "UMassAthletics"), n = 50, token = auth) #we will collect the recent 50 tweets from each of the three accounts, respectively. 
?get_timeline() #pull up help document on the function

### Group 4: the get_followers function. 
#Challenge 4:Pick an Twitter accounts. Get 100 followers from the accounts. DO NOT set the Twitter rate limits to refresh every 15 minutes.
followers <- get_followers("UMassDACSS", token = auth) #get a user's followers
?get_followers() #pull up help document on the function

### Group 5: the get_friends function. 
#Challenge 4:Pick an Twitter accounts. Get 100 friends from the accounts. DO NOT set the Twitter rate limits to refresh every 15 minutes.
friends <- get_friends("UMassDACSS", token = auth) #get a user's followers
?get_friends() #pull up help document on the function


