library(tm)
library(RColorBrewer)
library(wordcloud)
library(twitteR)

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

tdm = TermDocumentMatrix(
  myCorpus,
  control = list(
    removePunctuation = TRUE,
    stopwords = c(termos, stopwords("english")),
    removeNumbers = TRUE, tolower = TRUE)
)

m = as.matrix(tdm)
# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing = TRUE) 
# create a data frame with words and their frequencies
dm = data.frame(word = names(word_freqs), freq = word_freqs)
#dm$word
wordcloud(dm$word, dm$freq, random.order = FALSE, colors = brewer.pal(8, "Dark2"))