library(syuzhet)
library(lubridate)
library(ggplot2)
library(scales)
library(reshape2)
library(dplyr)
library(twitteR)
library(stringr)

# arquivo configuração
source("conf.R")

# carregando tweets
tweets = readRDS(arquivo)
tweets.df = twListToDF(tweets)
tweets.df$text = sapply(tweets.df$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
#mytext = tweets.df$text[c(1:3000)]
mytext = tweets.df$text

mySentiment <- get_nrc_sentiment(mytext)

tweets <- cbind(mytext, mySentiment)

sentimentTotals <- data.frame(colSums(tweets[,c(2:9)]))
sentimentTotals

names(sentimentTotals) <- "count"
sentimentTotals <- cbind("sentiment" = rownames(sentimentTotals), sentimentTotals)
rownames(sentimentTotals) <- NULL
ggplot(data = sentimentTotals, aes(x = sentiment, y = count)) +
  geom_bar(aes(fill = sentiment), stat = "identity") +
  theme(legend.position = "none") +
  xlab("Sentiment") + ylab("Total Count") + ggtitle("Total Sentiment Score for All Tweets")

