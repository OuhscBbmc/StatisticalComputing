#This is one of several ways to create boxplots in R.

rm(list=ls(all=TRUE))  #Clears variables from previous runs.

#Create some pretend data.
#   For the purposes of a boxplot, don't worry about the details).
fakeData <- data.frame(
  Weight=rnorm(n=100, mean=150, sd=30),
  Gender=rep(c("Male", "Female"),each=50),
  Category=rep(c("Normal", "Heavy"), times=50)
)

boxplot(
  formula = Weight ~ Gender + Category, #Specify the equation in the form: DV ~ IV1 + IV2
  data = fakeData,  #Specify the dataset
  main = "Weight Boxplot", #Declare the main title.
  xlab = "Groups", #Declare the label for the x-axis.
  ylab = "Weight (in lbs)" #Declare the label for the y-axis.
) 
