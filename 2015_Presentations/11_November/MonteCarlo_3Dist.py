samples = 200

r = 0.83
r2 = 0.33
r3 = 0.56


# Generate pearson correlated data with approximately cor(X, Y) = r

import numpy as np

data = np.random.multivariate_normal([0, 0, 0 ], [[1, r, r2], [r, 1, r3], [r2, r3, 1] ], size=samples)

#X, Y = data[:,0], data[:,1]

X,Y,Z = data[:,0], data[:,1], data[:,2]

#X, Y = data[:,0], data[:,1]

# That's it! Now let's take a look at the actual correlation:

import scipy.stats as stats

print 'r=', stats.pearsonr(X, Y)[0]
print 'r2=', stats.pearsonr(X, Z)[0]
print 'r3=', stats.pearsonr(Y, Z)[0]
