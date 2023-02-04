library(tweetbotornot2)

## vector of screen names
screen_names <- c(
  "American__Voter", ## (these ones should be bots)
  "MagicRealismBot",
  "netflix_bot",
  "mitchhedbot",
  "rstats4ds",
  "thinkpiecebot",
  "tidyversetweets",
  "newstarsbot",
  "CRANberriesFeed",
  "AOC",             ## (these ones should NOT be bots)
  "realDonaldTrump",
  "NateSilver538",
  "ChadPergram",
  "kumailn",
  "mindykaling",
  "hspter",
  "rdpeng",
  "kearneymw",
  "dfreelon",
  "AmeliaMN",
  "winston_chang"
)

## data frame with screen names **must be named 'screen_name'**
screen_names_df <- data.frame(screen_name = screen_names)

## vector -> bot estimates
predict_bot(screen_names)

