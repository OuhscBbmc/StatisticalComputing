#Clear the variables from previous runs.
rm(list=ls(all=TRUE))

#Load necessary packages
require(tm)
require(wordcloud)

#Read in source of data
df <- read.csv("C:/Users/twilson/Documents/GitHub/StatisticalComputing/2014_Presentations/04_April/Text.csv")

#Creates Word corpus
StateOfTheUnionCorpus <- Corpus(DataframeSource(data.frame(df[, 1])))

#Removes Punctuation from the corpus
StateOfTheUnionCorpus <- tm_map(StateOfTheUnionCorpus, removePunctuation)

#Changes all text to lower case
StateOfTheUnionCorpus <- tm_map(StateOfTheUnionCorpus, tolower)

#Creates a function to remove the English Stopwords
StateOfTheUnionCorpus <- tm_map(StateOfTheUnionCorpus, function(x) removeWords(x, stopwords("english")))

#See the list of stopwords
stopwords("english")

#Creates the Term Document Matrix
tdm <- TermDocumentMatrix(StateOfTheUnionCorpus)

#View the Term Document Matrix
tdm

#Creates a Matrix of the words and their frequencies
m <- as.matrix(tdm)

#Sorts in decreasing order
v <- sort(rowSums(m), decreasing = TRUE)

#Creates a dataframe from v
d <- data.frame(word = names(v), freq=v)

#Creates a color pallette for use in the wordcloud
pal2 <- brewer.pal(8, "Set2")
pal3 <- brewer.pal(8, "Dark2")
pal4 <- brewer.pal(8, "Accent")
pal5 <- c("#000000", "#BEAED4", "#FDC086", "#FFFF99", "#386CB0", "#F0027F", "#0000FF", "#FF0000")

#Arguments in the word cloud
#wordcloud(argument 1, argument 2, scale=c(4,.4),min.freq=0,max.words=Inf, random.order=F, rot.per=.3, colors=pal2)
#argument 1: the words
#argument 2: their frequencies
#scale: vector of length 2 indicating the ranges of the size of the words
#min.freq: sets the minimum frequency to be included in the wordcloud
#max.words: maximum number of words to be plotted.  Lesser frequency words are dropped
#random.order: plots words in random order.  If false, they are plotted in decreasing frequency
#rot.per: proportion of words with 90 degree rotation
#colors: color words from least to most frequent

#Creates the actual word cloud
wordcloud(d$word,d$freq, scale=c(4,.4),min.freq=0,max.words=Inf, random.order=F, rot.per=.3, colors=pal2)

####################################################################
#another option for removing words
myStopwords <- c(stopwords("english"), "will", "may")
StateOfTheUnionCorpus <- tm_map(StateOfTheUnionCorpus, function(x) removeWords(x, myStopwords))

tdm <- TermDocumentMatrix(StateOfTheUnionCorpus)

m <- as.matrix(tdm)
v <- sort(rowSums(m), decreasing = TRUE)
d <- data.frame(word = names(v), freq=v)
pal2 <- brewer.pal(8, "Set2")
wordcloud(d$word,d$freq, scale=c(4,.4),min.freq=0,max.words=Inf, random.order=F, rot.per=.3, colors=pal3)



