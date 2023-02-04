library(RedditExtractoR)

top_urls <- find_thread_urls(subreddit="umass", sort_by="top")
str(top_urls)

threads_contents <- get_thread_content(top_urls$url[1:2]) 
comments <- threads_contents$comments
threads <- threads_contents$threads
