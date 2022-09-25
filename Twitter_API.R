library(rtweet)
library(readr)

#replace the following API credentials with the one posted. 
# this is my comments

# run the following to read the vignette on authentication with the Twitter API
vignette('auth')

# set up your own authentication 
auth_setup_default() 

# or use app based authentication, run this code
auth <- rtweet_app()

#now test if we can connect to the API by searching 100 recent tweets that contain a keyword of your interest.  
tweets <- search_tweets("#ukraine", token = auth)

# or use the old way to authenticate your app. The create_token function was was deprecated in rtweet 1.0.0.
mytoken <- create_token(
  
  app = "R_Workshop_DB",
  
  consumer_key = "4EL1tCE2DG4OdtLrynOGnWsHi",
  
  consumer_secret = "57Urg78Zkpoqj4M6ZPL8TOXp7X4o0IM4Thh2FzmUGrm0TmgviD",
  
  access_token = "17917334-QzAR7yu42izruhOLsQEzVbHOVwXYHj0BrhMkqhJne",
  
  access_secret = "fvNA7z3Sb1nVfmqCIEJvDxkIWyvGlkbe6xXgscnXFlvzj") 

#now test if we can connect to the API by searching 100 recent tweets that contain a keyword of your interest.  
tweets1 <- search_tweets("#UMassAmherst", n = 100, token=mytoken)


