#This is a starter stub for the demo
rm(list=ls(all=TRUE))  #Clears variables from previous runs

#Load the required packages
require(plyr)

#Establish factor/character variables
mtcars$amS <- ifelse(mtcars$am==1, "Auto", "Manual")
mtcars$cylF <- factor(mtcars$cyl, levels=c(4, 6, 8), labels = c("Four", "Six", "Eight"))

#Custom function 3 from the presentation
SummarizeCars <- function( d ) {
  data.frame(
    RowCount = nrow(d),       
    MinHp = min(d$hp, na.rm=T),
    MaxWt = max(d$wt, na.rm=T)
  )}

# Mark: Return the heaviest car in each class/subset
SummarizeCars <- function( d ) {
  dsHighest <- d[d$wt == max(d$wt), ]
  #   dsHighest <- d[rank(d$wt)==1, ] #Watch out for ties.
  return( dsHighest )
}
# Jeet: Summarize the mpg for each class of cars.
SummarizeCars <- function( d ) { #Reusable function
  data.frame(
    MeanMpg = mean(d$mpg, na.rm=T),
    MinMpg = min(d$mpg, na.rm=T),
    MaxMpg = max(d$mpg, na.rm=T)
  )
}
ddply(mtcars, c("amS"), SummarizeCars)
ddply(mtcars, c("cylF", "amS"), SummarizeCars)

# David: don't summarize, but include a new variable with the class's average mpg
AugmentCars <- function( d ) {
  d$MeanMpg <- mean(d$mpg)
  return( d )
}
ddply(mtcars, c("cylF", "amS"), AugmentCars)
