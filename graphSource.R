library(twitteR)
tweets = readRDS('tweets.rds')
tweets.df = twListToDF(tweets)
par(mar = c(3, 3, 3, 2))
tweets.df$statusSource = substr(tweets.df$statusSource, 
                        regexpr('>', tweets.df$statusSource) + 1, 
                        regexpr('</a>', tweets.df$statusSource) - 1)

tbl = sort(table(tweets.df$statusSource))
dotchart(tbl)
mtext('Sources platforms')

#dotchart(tail(tbl, 20))
#mtext('Top 20 sources platforms')
