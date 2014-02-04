#This is a starter stub for the demo
rm(list=ls(all=TRUE))  #Clears variables

#Load the required packages
require(knitr)
require(plyr)
require(reshape)
require(ggplot2)

#Establish factors
mtcars$amS <- ifelse(mtcars$am==1, "Auto", "Manual")
mtcars$cylF <- factor(mtcars$cyl, levels=c(4, 6, 8), labels = c("Four", "Six", "Eight"))

#Custom function 3
SummarizeCars <- function( d ) { #Reusable function
  data.frame(
    RowCount = nrow(d),       
    MinHp = min(d$hp, na.rm=T),
    MaxWt = max(d$wt, na.rm=T)
  )}
ddply(mtcars, c("cylF"), SummarizeCars)
ddply(mtcars, c("cylF", "amS"), SummarizeCars)
