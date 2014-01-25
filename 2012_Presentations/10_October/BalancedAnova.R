		###### read.csv reads in the dataset as a csv file
		###### You may have to figure out where R's native root folder is.
		###### Mine is set up to be in the root folder where 
	
bullets = read.csv("c:/RSAS_UserDemo/datasets/bullet.csv")

		###### View the first 6 observations of the bullets dataset
head(bullets)

		###### Analyze dataset using the 'lm' command. 
		###### Type ?lm to see more details
		###### Also, I'm creating an object to reference later (I called it mod1)
mod1 = lm(Velocity~Powder, data=bullets)
summary(mod1)		


		###### normal probability plot uses the function 'qqnorm'
		###### first we subset the data to get only observations where powder =1, then 2, etc
p1 = subset(bullets, Powder==1)$Velocity
		###### this subsets the dataset called 'bullets', finding those rows where Powder is equal to 1
		###### The '$Velocity' part tells us to grab only the variable 'Velocity'		
p2 = subset(bullets, Powder==2)$Velocity		

		###### This sets the graphical parameters. mar refers to the margins (bottom, left, top, right)
		###### mgp specifies how far from the axes the axis labels, the numbers, and the tick marks fall
		###### mfrow gives multiple plots in one window, the parameters specify how many rows and columns 			###### there are
par(mfrow=c(2,1), mar=c(2.5,2.5,2,1), mgp=c(1.5, .5, 0))

		###### qqnorm only takes a single argument, a vector of data that it will plot the normal-ness of
qqnorm(p1)
		###### draw a line where the theoretical quantiles should match
qqline(p1)
		###### and repeat the procedure
qqnorm(p1, main="")
		##### main tells you what to label the top of the plot as.....specifying it as "" leaves it blank
qqline(p1)


		####### This part creates a boxplot
boxplot(Velocity~Powder, data=bullets)		

