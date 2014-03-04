##I got the kaps package code from the following link
##http://arxiv.org/pdf/1306.4615.pdf

##I got the sas7bat package code from the following link
##http://cran.r-project.org/web/packages/sas7bdat/sas7bdat.pdf


##set your working directory
setwd("D:/Files from Mac/SASRUserGroup")


##I have already installed the two packages we will be using today
##You will have to install them on your computer before you do the next step


##Load these two packages for use in current session
library("kaps")
library(sas7bdat)


##Import the SAS file using the sas7bat package
##Make sure your ordered prognostic variable is numeric
usergroup<-read.sas7bdat(file="D:/Files from Mac/SASRUserGroup/kaps.sas7bdat")


##Check that our data looks like it should
usergroup


##kaps will not run with blank values
##must create a dataset with no blank values
tstage <- na.omit(usergroup)


##Check that we have removed the one row with a missing value
tstage


##output the results for kaps program with predetermined number of group 
out1 <-kaps(Surv(Overall_Survival, cens) ~ trank, data=tstage, K=2)

##print the results
out1

##create the Kaplan-Meier survival curve plot
plot(out1)



##output the results for  kaps program allowing it to determine the optimal number of groups
out2 <-kaps(Surv(Overall_Survival, cens) ~ trank, data=tstage, K=2:4)

##print the results
out2

##create the Kaplan-Meier survival curve plot
plot(out2)