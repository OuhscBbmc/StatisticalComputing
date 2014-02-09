#This is a starter stub for the demo
rm(list=ls(all=TRUE))  #Clears variables from previous runs

#Load the required packages
require(plyr)

#Establish factor/character variables. In real code, spell out 'string' and 'factor'.
mtcars$amS <- ifelse(mtcars$am==1, "Auto", "Manual")
mtcars$cylF <- factor(mtcars$cyl, levels=c(4, 6, 8), labels = c("Four", "Six", "Eight"))

#Custom function 3 from Slide 22 of the presentation
SummarizeCars <- function( d ) {
  data.frame(
    RowCount = nrow(d),       
    MinHp = min(d$hp, na.rm=T),
    MaxWt = max(d$wt, na.rm=T)
)}
ddply(mtcars, c("amS"), SummarizeCars)

# Mark: Return the heaviest car in each class/subset
SummarizeCars <- function( d ) {
  dsHighest <- d[d$wt == max(d$wt), ]
  
  #Or consider which tie method is appropriate for your scenario.
  #  dsHighest <- d[rank(d$wt, ties.method="first")==1, ] 
  return( dsHighest )
}
ddply(mtcars, c("amS"), SummarizeCars)

# Jeet's suggestion: Summarize the mpg for each class of cars.
SummarizeCars <- function( d ) { #Reusable function
  data.frame(
    MeanMpg = mean(d$mpg, na.rm=T),
    MinMpg = min(d$mpg, na.rm=T),
    MaxMpg = max(d$mpg, na.rm=T)
  )
}
ddply(mtcars, c("amS"), SummarizeCars)
ddply(mtcars, c("cylF", "amS"), SummarizeCars)

# David's suggestion: don't summarize/collapse, but include a new variable with the class's average mpg
AugmentCars <- function( d ) {
  d$MeanMpg <- mean(d$mpg) #Equivalent to using the `transform` fx in ddply.
  return( d )
}
ddply(mtcars, c("cylF", "amS"), AugmentCars)
