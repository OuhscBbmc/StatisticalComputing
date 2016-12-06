library(nimble);library(igraph);library(ggplot2);library(ggExtra)
myBUGScode <- nimbleCode({mu ~ dnorm(0, sd = 100) 
                          sigma ~ dunif(0, 100) 
                          for(i in 1:10) y[i] ~ dnorm(mu, sd = sigma)})
myModel <- nimbleModel(myBUGScode)
plot(myModel$getGraph())
myData <- rnorm(10, mean = 2, sd = 5) 
myModel$setData(list(y = myData)) 
myModel$setInits(list(mu = 0, sigma = 1))
myMCMC <- buildMCMC(myModel)
compiled <- compileNimble(myModel, myMCMC)
compiled$myMCMC$run(10000)
samples <- as.matrix(compiled$myMCMC$mvSamples)
# marginal posterior density
plot(density(samples[,'mu']))
plot(density(samples[,'sigma']))

f1 <- data.frame(mu=samples[,'mu'], sigma=samples[,'sigma'])
(p1 <- ggplot(df1, aes(mu, sigma)) + geom_point() + theme_bw())
ggMarginal(p1)
ggMarginal(p1, type = "histogram", xparams = list(binwidth = 1, fill = "orange"))

# traceplots for each parameter
plot(samples[ , 'mu'], type = 'l', xlab = 'iteration',  ylab = expression(mu))
plot(samples[ , 'sigma'], type = 'l', xlab = 'iteration', ylab = expression(sigma))

## Figure showing ACFs
acf1 <- with(acf(samples[, 'mu'], plot = FALSE), data.frame(lag, acf))
acf1$param <- 'mu'
acf2 <- with(acf(samples[, 'sigma'], plot = FALSE), data.frame(lag, acf))
acf2$param <- 'sigma'

acfall <- do.call('rbind', list(acf1, acf2))
acfall <- acfall[acfall$lag <= 20, ]

## line plot version
acfplot <- ggplot(data=acfall, mapping=aes(x=lag, y=acf)) +
        geom_line(stat = "identity", position = "identity") + 
        facet_wrap(~param, ncol = 1)  + theme(legend.position="top", 
        legend.title = element_blank(), 
        text = element_text(size = 8)) + ylab('MCMC autocorrelation')
print(acfplot)
