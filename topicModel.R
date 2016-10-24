library(tm)
library(RColorBrewer)
library(wordcloud)
library(twitteR)
library(topicmodels)
library(ggplot2)

# arquivo configuração
source("conf.R")

# carregando tweets
tweets = readRDS(arquivo)
# convertendo twitterR list para data frame
tweets.df = twListToDF(tweets)
# retirar caracteres estranhos
tweets.df$text = sapply(tweets.df$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
# criando corpus
myCorpus = Corpus(VectorSource(tweets.df$text))

myCorpus <- tm_map(myCorpus, content_transformer(tolower))


#removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
### myCorpus <- tm_map(myCorpus, removeURL, lazy=TRUE) 
#myCorpus <- tm_map(myCorpus, content_transformer(removeURL))  #??

myStopwords <- c(stopwords("english"), "bob", "dylan")
myStopwords

# remove stopwords from corpus
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)



writeLines(as.character(myCorpus[[3]]))

tdm = TermDocumentMatrix(
  myCorpus,
  control = list(
    removePunctuation = TRUE,
    stopwords = c(stopwords("english")),
    removeNumbers = TRUE, tolower = TRUE)
)

dtm <- as.DocumentTermMatrix(tdm)

rowTotals <- apply(dtm , 1, sum) #Find the sum of words in each Document
dtm.new   <- dtm[rowTotals> 0, ]           #remove all docs without words

lda <- LDA(dtm.new, k = 8) # find 8 topics
term <- terms(lda, 4) # first 4 terms of every topic
term


term <- apply(term, MARGIN = 2, paste, collapse = ", ")

# first topic identified for every document (tweet)
require(data.table) #fore IDate
p
topic <- topics(lda, 1)
topics <- data.frame(date=as.IDate(tweets.df$created[999]), topic)
qplot(date, ..count.., data=topics, geom="density",
      fill=term[topic], position="stack")

