library(sentimentr)
library(twitteR)

# arquivo configuração
source("conf.R")

# carregando tweets
tweets = readRDS(arquivo)
tweets.df = twListToDF(tweets)
tweets.df$text = sapply(tweets.df$text,function(row) iconv(row, "latin1", "ASCII", sub=""))

mytext = tweets.df$text

mysentiment = sentiment(mytext)
mysentiment$polaridade =  ifelse (mysentiment$sentiment < 0,"negativo" , "positivo")
mysentiment$polaridade =  ifelse (mysentiment$sentiment == 0,"neutro",mysentiment$polaridade)


mysentiment

cores = c("#ff0000FF", "#00ff00FF","#0000FFFF")

barplot(table(as.factor(mysentiment$polaridade)),
        col=cores,
        main = "Polaridades")
