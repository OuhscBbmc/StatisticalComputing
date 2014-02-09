<style type="text/css">
.small-code pre code {
   font-size: 1.1em;
}
</style>

Data Manipulation in R: Using the `plyr` package and other tools
========================================================
OUHSC [Statistical Computing User Group](https://github.com/OuhscBbmc/StatisticalComputing)

Will Beasley, Dept of Pediatrics, Biomedical and Behavioral Methodology Core ([BBMC](http://ouhsc.edu/BBMC/))

[February 4, 2014](https://github.com/OuhscBbmc/StatisticalComputing/tree/master/2014_Presentations/02_February/)

Basic Manipulations -Part 1
========================================================
The building block operations *briefly* covered today are

- Array
- `data.frame`
- Inspection of data
- Subsetting rows & columns
- Programmatic cleaning
- Factors
- Merging
- Converting between long & wide datasets (`reshape2`)

Basic Manipulations -Part 2
========================================================
The operations more thoroughly covered today are

- Transforming within groups (`plyr`)
- Summarizing within groups (`plyr`)


```r
#Load the required packages
require(knitr)
require(plyr)
require(reshape)
require(ggplot2)
```


Arrays (brief)
========================================================
class: small-code

```r
x <- c(0, 2, 6, 9, 11, 12)    #Create IV array
y <- c(6, 3, 4, 10, 8, 6.5)   #Create DV array
m <- c(T, T, T, F, F, F)      #Create binary array
```


```r
x * 100                       #Multiply by a scalar
```

```
[1]    0  200  600  900 1100 1200
```

```r
x + y                         #Add equal-length vectors
```

```
[1]  6.0  5.0 10.0 19.0 19.0 18.5
```

```r
x * as.integer(m)             #Multiply equal-length vectors
```

```
[1] 0 2 6 0 0 0
```

```r
scale(x, center=mean(x))      #Vector-wide function
```

```
        [,1]
[1,] -1.3646
[2,] -0.9552
[3,] -0.1365
[4,]  0.4776
[5,]  0.8870
[6,]  1.0917
attr(,"scaled:center")
[1] 6.667
attr(,"scaled:scale")
[1] 4.885
```


`data.frame` (brief)
========================================================
class: small-code

```r
dsSimple <- data.frame(X=x, Y=y, M=m, stringsAsFactors=F)

head(dsSimple)
```

```
   X    Y     M
1  0  6.0  TRUE
2  2  3.0  TRUE
3  6  4.0  TRUE
4  9 10.0 FALSE
5 11  8.0 FALSE
6 12  6.5 FALSE
```


Inspection of data.frame (brief)
========================================================
class: small-code

```r
summary(dsSimple)
```

```
       X               Y             M          
 Min.   : 0.00   Min.   : 3.00   Mode :logical  
 1st Qu.: 3.00   1st Qu.: 4.50   FALSE:3        
 Median : 7.50   Median : 6.25   TRUE :3        
 Mean   : 6.67   Mean   : 6.25   NA's :0        
 3rd Qu.:10.50   3rd Qu.: 7.62                  
 Max.   :12.00   Max.   :10.00                  
```

```r
sapply(dsSimple, class)
```

```
        X         Y         M 
"numeric" "numeric" "logical" 
```

```r
str(dsSimple)
```

```
'data.frame':	6 obs. of  3 variables:
 $ X: num  0 2 6 9 11 12
 $ Y: num  6 3 4 10 8 6.5
 $ M: logi  TRUE TRUE TRUE FALSE FALSE FALSE
```


Inspection of list (brief)
========================================================
class: small-code

```r
l <- list(a=rnorm(10), b=data.frame(b1= rnorm(5), b2=rnorm(5)))
str(l) #Notice how b1 & b2 are shown nested in b.
```

```
List of 2
 $ a: num [1:10] 1.056 1.117 -0.154 -0.494 0.283 ...
 $ b:'data.frame':	5 obs. of  2 variables:
  ..$ b1: num [1:5] -0.164 1.503 1.204 0.719 0.622
  ..$ b2: num [1:5] -0.298 -0.27 -0.336 -1.217 1.645
```

```r
sapply(l, class)
```

```
           a            b 
   "numeric" "data.frame" 
```


Subsetting rows & columns (brief)
========================================================
class: small-code

```r
x
```

```
[1]  0  2  6  9 11 12
```

```r
(xSubset1 <- x[m])
```

```
[1] 0 2 6
```

```r
(xSubset2 <- x[c(1,4,5)])
```

```
[1]  0  9 11
```

Subsetting rows & columns (brief)
========================================================
class: small-code

```r
dsSimple$X
```

```
[1]  0  2  6  9 11 12
```

```r
(xSubset1 <- x[m])
```

```
[1] 0 2 6
```

```r
(xSubset2 <- dsSimple$X[c(1,4,5)])
```

```
[1]  0  9 11
```

```r
(xSubset3 <- dsSimple[c(1,4,5), c("X", "Y")])
```

```
   X  Y
1  0  6
4  9 10
5 11  8
```


Programmatic cleaning (brief)
========================================================
class: small-code

```r
(x2 <- x) #Declare a copy of the same variable
```

```
[1]  0  2  6  9 11 12
```

```r
y
```

```
[1]  6.0  3.0  4.0 10.0  8.0  6.5
```

```r
x2[y < 5] <- NA
x2
```

```
[1]  0 NA NA  9 11 12
```

```r
x3 <- ifelse(test=y<5, yes=NA, no=x)
x3
```

```
[1]  0 NA NA  9 11 12
```


Another Example Dataset (again)
========================================================
class: small-code
The `mtcars` is from the `datasets` package.


```r
kable(head(mtcars[, ]), format = "markdown")
```

|id                 |   mpg|  cyl|  disp|   hp|  drat|     wt|   qsec|  vs|  am|  gear|  carb|
|:------------------|-----:|----:|-----:|----:|-----:|------:|------:|---:|---:|-----:|-----:|
|Mazda RX4          |  21.0|    6|   160|  110|  3.90|  2.620|  16.46|   0|   1|     4|     4|
|Mazda RX4 Wag      |  21.0|    6|   160|  110|  3.90|  2.875|  17.02|   0|   1|     4|     4|
|Datsun 710         |  22.8|    4|   108|   93|  3.85|  2.320|  18.61|   1|   1|     4|     1|
|Hornet 4 Drive     |  21.4|    6|   258|  110|  3.08|  3.215|  19.44|   1|   0|     3|     1|
|Hornet Sportabout  |  18.7|    8|   360|  175|  3.15|  3.440|  17.02|   0|   0|     3|     2|
|Valiant            |  18.1|    6|   225|  105|  2.76|  3.460|  20.22|   1|   0|     3|     1|


```r
sapply(mtcars, class)
```

```
      mpg       cyl      disp        hp      drat        wt      qsec 
"numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" 
       vs        am      gear      carb 
"numeric" "numeric" "numeric" "numeric" 
```


Factors 1 (brief)
========================================================
class: small-code   

```r
mtcars$am
```

```
 [1] 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 1 1 1 1 1 1 1
```

```r
(mtcars$amF <- factor(mtcars$am, levels=c(0, 1), 
                      labels=c("Auto", "Manual")))
```

```
 [1] Manual Manual Manual Auto   Auto   Auto   Auto   Auto   Auto   Auto  
[11] Auto   Auto   Auto   Auto   Auto   Auto   Auto   Manual Manual Manual
[21] Auto   Auto   Auto   Auto   Auto   Manual Manual Manual Manual Manual
[31] Manual Manual
Levels: Auto Manual
```

```r
(mtcars$amS <- ifelse(mtcars$am==1, "Auto", "Manual"))
```

```
 [1] "Auto"   "Auto"   "Auto"   "Manual" "Manual" "Manual" "Manual"
 [8] "Manual" "Manual" "Manual" "Manual" "Manual" "Manual" "Manual"
[15] "Manual" "Manual" "Manual" "Auto"   "Auto"   "Auto"   "Manual"
[22] "Manual" "Manual" "Manual" "Manual" "Auto"   "Auto"   "Auto"  
[29] "Auto"   "Auto"   "Auto"   "Auto"  
```

```r
mtcars$amF <- NULL
```


Factors 2 (brief)
========================================================
class: small-code

```r
mtcars$cyl
```

```
 [1] 6 6 4 6 8 6 8 4 4 6 6 8 8 8 8 8 8 4 4 4 4 8 8 8 8 4 4 4 8 6 8 4
```

```r
(mtcars$cylF <- factor(mtcars$cyl, levels=c(4, 6, 8), 
                       labels = c("Four", "Six", "Eight")))
```

```
 [1] Six   Six   Four  Six   Eight Six   Eight Four  Four  Six   Six  
[12] Eight Eight Eight Eight Eight Eight Four  Four  Four  Four  Eight
[23] Eight Eight Eight Four  Four  Four  Eight Six   Eight Four 
Levels: Four Six Eight
```

```r
#Notice empty levels (ie, Four and Eight) are still defined
mtcars[mtcars$cyl==6, "cylF"] 
```

```
[1] Six Six Six Six Six Six Six
Levels: Four Six Eight
```


Merging (brief)
========================================================
No sorting necessary.  Type `?merge` for help.
```
dsJoin1 <- merge(
  x = dsSurvey, 
  y = dsRecruit, 
  by = "RecruitID", 
  all.x = TRUE, 
  all.y = FALSE
)
```
```
dsJoin2 <- plyr::join(
  x = dsSurvey, 
  y = dsRecruit, 
  by = "RecruitID", 
  type = "left",
  match = "all"
)
```

Converting long & wide (brief; `reshape2`)
========================================================
class: small-code

SubjectID | Time1BP | Time2BP | Time3BP | Time4BP | Time5BP
--------- | ------- | ------- | ------- | ------- | ------
1 | 11 | 12 | 13 | 14 | 15 
2 | 21 | 22 |  - |  - |  -
3 | 31 | 32 | 33 | 34 |  -

SubjectID | Time | BP
--------- | ---- | ---
1 | 1 | 11
1 | 2 | 12
... |
2 | 1 | 22
... |
3 | 2 | 32
3 | 3 | 33
3 | 4 | 34

Another Example Dataset (again)
========================================================
class: small-code

```r
kable(head(mtcars[, ]), format = "markdown")
```

|id                 |   mpg|  cyl|  disp|   hp|  drat|     wt|   qsec|  vs|  am|  gear|  carb|amS     |cylF   |
|:------------------|-----:|----:|-----:|----:|-----:|------:|------:|---:|---:|-----:|-----:|:-------|:------|
|Mazda RX4          |  21.0|    6|   160|  110|  3.90|  2.620|  16.46|   0|   1|     4|     4|Auto    |Six    |
|Mazda RX4 Wag      |  21.0|    6|   160|  110|  3.90|  2.875|  17.02|   0|   1|     4|     4|Auto    |Six    |
|Datsun 710         |  22.8|    4|   108|   93|  3.85|  2.320|  18.61|   1|   1|     4|     1|Auto    |Four   |
|Hornet 4 Drive     |  21.4|    6|   258|  110|  3.08|  3.215|  19.44|   1|   0|     3|     1|Manual  |Six    |
|Hornet Sportabout  |  18.7|    8|   360|  175|  3.15|  3.440|  17.02|   0|   0|     3|     2|Manual  |Eight  |
|Valiant            |  18.1|    6|   225|  105|  2.76|  3.460|  20.22|   1|   0|     3|     1|Manual  |Six    |


```r
sapply(mtcars, class)
```

```
        mpg         cyl        disp          hp        drat          wt 
  "numeric"   "numeric"   "numeric"   "numeric"   "numeric"   "numeric" 
       qsec          vs          am        gear        carb         amS 
  "numeric"   "numeric"   "numeric"   "numeric"   "numeric" "character" 
       cylF 
   "factor" 
```


The `plyr` package
========================================================
* **split** the dataset into subsets, based on factors
* **apply** an arbitrary function to each subset
* **combine** the subsets back into a single dataset

With respect to records, the *apply* function can be 
* **1-to-1** (a transformation)
* **many-to-1** (a summary)
* **1-to-many** (an expansion)


Transforming within groups (`plyr`)
========================================================
class: small-code

```r
tr <- ddply(.data = mtcars,               #Dataset to split
            .variables = c("cylF", "amS"),#Splitting Variables
            .fun = transform,             #It's 1-to-1
            z_mpg = round(scale(mpg), 1), #New variable
            ratio = hp / wt               #New variable
)
tr[, c("amS","cylF","mpg","z_mpg","hp","wt","ratio")] #Subset
```

```
      amS  cylF  mpg z_mpg  hp    wt ratio
1    Auto  Four 22.8  -1.2  93 2.320 40.09
2    Auto  Four 32.4   1.0  66 2.200 30.00
3    Auto  Four 30.4   0.5  52 1.615 32.20
4    Auto  Four 33.9   1.3  65 1.835 35.42
5    Auto  Four 27.3  -0.2  66 1.935 34.11
6    Auto  Four 26.0  -0.5  91 2.140 42.52
7    Auto  Four 30.4   0.5 113 1.513 74.69
8    Auto  Four 21.4  -1.5 109 2.780 39.21
9  Manual  Four 24.4   1.0  62 3.190 19.44
10 Manual  Four 22.8  -0.1  95 3.150 30.16
11 Manual  Four 21.5  -1.0  97 2.465 39.35
12   Auto   Six 21.0   0.6 110 2.620 41.98
13   Auto   Six 21.0   0.6 110 2.875 38.26
14   Auto   Six 19.7  -1.2 175 2.770 63.18
15 Manual   Six 21.4   1.4 110 3.215 34.21
16 Manual   Six 18.1  -0.6 105 3.460 30.35
17 Manual   Six 19.2   0.0 123 3.440 35.76
18 Manual   Six 17.8  -0.8 123 3.440 35.76
19   Auto Eight 15.8   0.7 264 3.170 83.28
20   Auto Eight 15.0  -0.7 335 3.570 93.84
21 Manual Eight 18.7   1.3 175 3.440 50.87
22 Manual Eight 14.3  -0.3 245 3.570 68.63
23 Manual Eight 16.4   0.5 180 4.070 44.23
24 Manual Eight 17.3   0.8 180 3.730 48.26
25 Manual Eight 15.2   0.1 180 3.780 47.62
26 Manual Eight 10.4  -1.7 205 5.250 39.05
27 Manual Eight 10.4  -1.7 215 5.424 39.64
28 Manual Eight 14.7  -0.1 230 5.345 43.03
29 Manual Eight 15.5   0.2 150 3.520 42.61
30 Manual Eight 15.2   0.1 150 3.435 43.67
31 Manual Eight 13.3  -0.6 245 3.840 63.80
32 Manual Eight 19.2   1.5 175 3.845 45.51
```


Summarizing within groups (`plyr`)
========================================================
class: small-code

```r
su <- ddply(.data = mtcars,               #Dataset to split
            .variables = c("cylF", "amS"),#Splitting Variables
            .fun = summarize,             #It's many-to-1
            count = sum(!is.na(mpg)),     #New variable
            ssqi = 3.2 - sqrt(sum(hp/wt)) #New variable
)
su                                        #All dataset columns
```

```
   cylF    amS count    ssqi
1  Four   Auto     8 -14.917
2  Four Manual     3  -6.231
3   Six   Auto     3  -8.776
4   Six Manual     4  -8.465
5 Eight   Auto     2 -10.109
6 Eight Manual    12 -20.819
```


Custom function 1 (`plyr`)
========================================================
class: small-code

```r
SummarizeCars1 <- function( d ) {
  dsNew <- data.frame(
    count = sum(!is.na(d$mpg)),           #Notice the new `d$`
    ssqi = 3.2 - sqrt(sum(d$hp / d$wt))   #Notice the new `d$`
  )
  return( dsNew )
}
su <- ddply(.data = mtcars,               #Dataset to split
            .variables = c("cylF", "amS"),#Splitting Variables
            .fun = SummarizeCars1         #Our new function
)
su
```

```
   cylF    amS count    ssqi
1  Four   Auto     8 -14.917
2  Four Manual     3  -6.231
3   Six   Auto     3  -8.776
4   Six Manual     4  -8.465
5 Eight   Auto     2 -10.109
6 Eight Manual    12 -20.819
```


Custom function 2 (`plyr`)
========================================================
class: small-code

```r
PassThrough <- function( d ) {
  d #returns the `d` dataset
}
su <- ddply(.data = mtcars,               #Dataset to split
            .variables = c("cylF", "amS"),#Splitting Variables
            .fun = PassThrough          #Our new function
)
su
```

```
    mpg cyl  disp  hp drat    wt  qsec vs am gear carb    amS  cylF
1  22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1   Auto  Four
2  32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1   Auto  Four
3  30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2   Auto  Four
4  33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1   Auto  Four
5  27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1   Auto  Four
6  26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2   Auto  Four
7  30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2   Auto  Four
8  21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2   Auto  Four
9  24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2 Manual  Four
10 22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2 Manual  Four
11 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1 Manual  Four
12 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4   Auto   Six
13 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4   Auto   Six
14 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6   Auto   Six
15 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1 Manual   Six
16 18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1 Manual   Six
17 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4 Manual   Six
18 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4 Manual   Six
19 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4   Auto Eight
20 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8   Auto Eight
21 18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2 Manual Eight
22 14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4 Manual Eight
23 16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3 Manual Eight
24 17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3 Manual Eight
25 15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3 Manual Eight
26 10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4 Manual Eight
27 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4 Manual Eight
28 14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4 Manual Eight
29 15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2 Manual Eight
30 15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2 Manual Eight
31 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4 Manual Eight
32 19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2 Manual Eight
```


Custom function 3 (`plyr`)
========================================================
class: small-code

```r
SummarizeCars2 <- function( d ) { #Reusable function
  data.frame(
    RowCount = nrow(d),       
    MinHp = min(d$hp, na.rm=T),
    MaxWt = max(d$wt, na.rm=T)
)}
ddply(mtcars, c("cylF"), SummarizeCars2)
```

```
   cylF RowCount MinHp MaxWt
1  Four       11    52 3.190
2   Six        7   105 3.460
3 Eight       14   150 5.424
```

```r
ddply(mtcars, c("cylF", "amS"), SummarizeCars2)
```

```
   cylF    amS RowCount MinHp MaxWt
1  Four   Auto        8    52 2.780
2  Four Manual        3    62 3.190
3   Six   Auto        3   110 2.875
4   Six Manual        4   105 3.460
5 Eight   Auto        2   264 3.570
6 Eight Manual       12   150 5.424
```


Stump the Band (`plyr`)
========================================================
I dislike sanitized demos that carefully and discreetly avoid weak spots.  Audiences get an inflated idea of the tool's ability and flexibility.

Tell me how you want `mtcars` manipulated. *In hindsight, this may be an awful idea.*

The `dplyr` package
========================================================
* The upcoming generation of `plyr`, which focuses almost exclusively on `data.frame`s.

* It uses a similar split-apply-combine logic, but with a syntax that's a little closer to SQL.

* Exciting that it can directly operate on a dataset that's in a remote database.  This can increase performance, because databases typically have more horsepower than your laptop.  Also can substantially reduce the network traffic if there's a lot of summarizing. 

* Still in the early development, and the syntax is still changing.

Resources
========================================================
#### Winston Chang
 * [*R Graphics Cookbook*](http://shop.oreilly.com/product/0636920023135.do)
 * [Cookbook for R](http://www.cookbook-r.com/) www.cookbook-r.com
 
#### Hadley Wickham
 * [The Split-Apply-Combine Strategy for Data Analysis](http://www.jstatsoft.org/v40/i01/), JSS
 * http://plyr.had.co.nz/
 * https://github.com/hadley/dplyr
 
#### Phil Spector
 * [*Data Manipulation with R*](http://www.springer.com/statistics/computational+statistics/book/978-0-387-74730-9)

#### Christopher Gandrud
 - [*Reproducible Research with R and RStudio*](http://christophergandrud.github.io/RepResR-RStudio/)
