#Demonstrate R objects
#vector assignment
x <- c(10.4, 5.6, 3.1, 6.4, 21.7,19.0)

#matrix
y <- matrix(x,2,3,byrow=T)

#data.frame
df <- as.data.frame(y)
colnames(df) <- c("var1","var2","var3")

#array
z <- array(x,c(2,3))
z3 <- array(x,c(2,1,3))

#list
h <- list(item1=x[1:2],item2=x[3:4],item3=x[5:6])
all <- list(x=x,y=y,df=df,z=z,z3=z3,h=h)




objects() #or ls()
rm(h)



#demonstrate help
help(mean)
#or 
?mean
?sd


#demonstrate open-source and method attributes
mean
methods("mean")
mean.default

#Demonstrate vector operations

#Most operations on collection objects work element-wise 
#so no need to manually loop through a vector 

a <- 1:10
b <- a+5
b

#You can operate selectively on certain indexed elements

c <- b
pos <- c(1,2,3,5,7)
c[pos] <- b[pos]*10
c

#Or operate on elements that meet certain specified demands

d <- c
d[d %% 2 == 0] <- -1
d

#Notice R looping tends to be more flexible than SAS
#Here we avoid restrictive retain command

e <- as.data.frame(cbind(rep(1:2,each=5),d))
colnames(e) <- c("ID","Value")
e
for(i in unique(e[,1])) { #create cumulative count of -1s per column value 
  index <- e[,1]==i & e[,2]==-1
  e[index,2] <- c(1:sum(index))   
}
e
    
#vector operations extend to assignment
e$mean2 <- mean(e[,2])
e

#SAS proc & data step code to do same task
#proc means data=rpract;
# var value;
# output out=meanval mean=mean;
# run;
# 
# data rpract2; 
# if _n_ = 1 then set meanval(keep=mean);
# set rpract; 
# run;

#Demonstrate program installation
install.packages("lme4")
library(lme4) #or require(lme4)








    