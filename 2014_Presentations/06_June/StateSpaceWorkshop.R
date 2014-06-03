#
#   Copyright 2007-2014 The OpenMx Project
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
# 
#        http://www.apache.org/licenses/LICENSE-2.0
# 
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

#------------------------------------------------------------------------------
# Author: Michael D. Hunter
# Email: mhunter@ou.edu
# Date: 2014.05.21
# Filename: StateSpaceWorkshop.R
# Purpose: Show basic functionality of the State Space expectation
#  for the APS OpenMx 2.0 Workshop
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# EXAMPLE 1

# Create and fit a model using mxMatrix, mxExpectationStateSpace, and mxFitFunctionML
require(OpenMx)
data(demoOneFactor)
nvar <- ncol(demoOneFactor)
varnames <- colnames(demoOneFactor)
ssModel <- mxModel(model="State Space Manual Example",
    mxMatrix("Full", 1, 1, TRUE, .3, name="A"),
    mxMatrix("Zero", 1, 1, name="B", dimnames=list("F1", "U1")),
    mxMatrix("Full", nvar, 1, TRUE, .6, name="C", dimnames=list(varnames, "F1")),
    mxMatrix("Zero", nvar, 1, name="D", dimnames=list(varnames, "U1")),
    mxMatrix("Diag", 1, 1, FALSE, 1, name="Q"),
    mxMatrix("Diag", nvar, nvar, TRUE, .2, name="R"),
    mxMatrix("Zero", 1, 1, name="x0"),
    mxMatrix("Diag", 1, 1, FALSE, 1, name="P0"),
    mxMatrix("Zero", 1, 1, name="u"),
    mxData(observed=demoOneFactor, type="raw"),
    mxExpectationStateSpace("A", "B", "C", "D", "Q", "R", "x0", "P0", "u"),
    mxFitFunctionML()
)
ssRun <- mxRun(ssModel)
summary(ssRun)

ssf <- mxModel(model=ssModel, name="Factor Model in State Space Form",
	mxMatrix("Zero", 1, 1, name="A")
)
ssfRun <- mxRun(ssf)

# Compare via Likelihood ratio test whether the autoregressive matrix
#  for the dynamic factor analysis should be all zero
#  That is, a non-dynamic (regular) factor analysis.
mxCompare(ssRun, ssfRun)

#--------------------------------------
# The same factor model as ssf/ssfRun but specified as a LISREL expectation
liModel <- mxModel(model=ssf, name="LISREL Factor Model",
	mxExpectationLISREL(LX="C", PH="Q", TD="R", TX="D", KA="B")
)

liRun <- mxRun(liModel)


summary(liRun)

summary(liRun)$parameters[,1:6]
summary(ssfRun)$parameters[,1:6]
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# Generate Data

require(mvtnorm)

set.seed(26)

ldim <- 3
udim <- 1
mdim <- 3*ldim
tdim <- 100
mA <- matrix(c(.7, 0, .1, 0, .8, .4, 0, -.4, .8), ldim, ldim)
mB <- matrix(0, ldim, udim)
mC <- matrix(c(1, 1.1, .9, rep(0, mdim), 1, 1.001, 1.001, rep(0, mdim), 1, .9, 1.1), mdim, ldim)
mD <- matrix(0, mdim, udim)
mQ <- diag(c(1.1, 1.5, 0.8), nrow=ldim)
mR <- diag(runif(mdim, .1, .25), nrow=mdim)
mX0 <- matrix(0, ldim, 1)
mI <- diag(1, nrow=ldim*ldim)
mP0 <- matrix(solve(mI - mA %x% mA) %*% c(mQ), ldim, ldim)
mU <- matrix(0, udim, tdim)
tx <- matrix(0, ldim, tdim+1)
ty <- matrix(0, mdim, tdim)


tx[,1] <- mX0
for(i in 1:tdim){
	tx[,i+1] <- mA %*% tx[,i] + mB %*% mU[,i] + t(rmvnorm(1, rep(0, ldim), mQ))
	ty[,i] <- mC %*% tx[,i+1] + mD %*% mU[,i] + t(rmvnorm(1, rep(0, mdim), mR))
}

op <- par(mfrow=c(3, 1))
plot(tx[1,], type='l')
plot(tx[2,], type='l')
plot(tx[3,], type='l')
par(op)

# Coupled variables are lagged
plot(tx[2,], type='l')
lines(tx[3,], lty=2)

rownames(ty) <- paste('y', 1:mdim, sep='')
rownames(tx) <- paste('x', 1:ldim, sep='')

theData <- cbind(t(ty), t(mU))
colnames(theData)[(mdim+1):(mdim+udim)] <- paste("input", 1:udim, sep="")

#------------------------------------------------------------------------------
# Specify State Space model for theData

amat <- mxMatrix("Full", ldim, ldim, values=mA, free=(mA!=0), name="A")
bmat <- mxMatrix("Zero", ldim, udim, name="B")
cmat <- mxMatrix("Full", mdim, ldim, values=mC, free=(mC!=0 & mC!=1), name="C", dimnames=list(rownames(ty), rownames(tx)))
dmat <- mxMatrix("Zero", mdim, udim, name="D")
qmat <- mxMatrix("Diag", ldim, ldim, free=TRUE, values=mQ, name="Q")
rmat <- mxMatrix("Diag", mdim, mdim, free=TRUE, values=mR, name="R")
xmat <- mxMatrix("Full", ldim, 1, free=FALSE, values=mX0, name="x0")
pmat <- mxMatrix("Full", ldim, ldim, free=FALSE, values=mP0, name="P0")
umat <- mxMatrix("Full", udim, 1, labels=c("data.input1"), name="u")


threeDimMod <- mxModel("3 Dim SSM",
	amat, bmat, cmat, dmat, qmat, rmat, xmat, pmat, umat,
	mxExpectationStateSpace("A", "B", "C", "D", "Q", "R", "x0", "P0", "u"),
	mxFitFunctionML(),
	mxData(theData, type="raw")
)


threeDimRun <- mxRun(threeDimMod)


#------------------------------------------------------------------------------
# Inspect Results

summary(threeDimRun)


mA
mxEval(A, threeDimRun)

# B is fixed to zero

mC
mxEval(C, threeDimRun)

# D is fixed to zero

mQ
mxEval(Q, threeDimRun)

diag(mR)
diag(mxEval(R, threeDimRun))


#------------------------------------------------------------------------------
# Examine equality and oppositeness of cross-regression x2-x3
amat.con1 <- mxMatrix("Full", ldim, ldim, values=mA, free=(mA!=0), name="A", labels=c('a11', NA, 'a13', NA, 'a22', 'a23', NA, 'a32[1,1]', 'a33'))
amat.con1$free[2,3] <- FALSE
amat.alg <- mxAlgebra(-a23, name='a32')

threeDimCon <- mxModel(model=threeDimMod, name='Constrained Three Dim Model',
	amat.con1, amat.alg
)


threeDimConRun <- mxRun(threeDimCon)


mxEval(A, threeDimConRun)
mxEval(A, threeDimRun)

mxCompare(threeDimRun, threeDimConRun)


#------------------------------------------------------------------------------
# Done
#------------------------------------------------------------------------------
