toInstall <- c("ggplot2", "scales", "R2WinBUGS", "devtools", "yaml", "httr", "RJSONIO")
install.packages(toInstall, repos = "http://cran.r-project.org")

library(devtools)
install_github("pablobarbera/twitter_ideology/pkg/tweetscores")

library(tweetscores)
library(rtweet)

auth <- rtweet_app()

friends <- get_friends("tedcruz", token = auth) #get a user's followers
friends<- friends$to_id

user <- "tedcruz"

# estimate ideology with MCMC method
results <- estimateIdeology(user, friends)

# summarizing results
summary(results)

# assessing chain convergence using a trace plot
tracePlot(results, "theta")

# comparing with other ideology estimates
plot(results)

