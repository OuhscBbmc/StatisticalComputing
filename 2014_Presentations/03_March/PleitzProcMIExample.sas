data Fitness;
input Id Oxygen RunTime RunPulse;
datalines;
1 44.609 	11.37 	178 
2 54.297 	8.65 	156 
3 49.874 	9.22 	. 	
4 . 		11.95 	176 
5 39.442 	13.08 	174 
6 50.541 	. 		. 	
7 44.754 	11.12 	176 
8 51.855 	10.33 	166 
9 40.836 	10.95 	168 
10 . 		10.25 	. 	
11 39.407 	12.63 	174 
12 45.441 	9.63 	164 
13 45.118 	11.08 	. 	
14 45.790 	10.47 	186 
15 48.673 	9.40 	186 
16 47.467 	10.50 	170 
17 45.313 	10.07 	185 
18 59.571 	. 		.   
19 44.811 	11.63 	176 
20 49.091 	10.85 	.   
21 60.055 	8.63 	170 
22 37.388 	14.03 	186 
23 47.273 	. 		.   
24 49.156 	8.95 	180 
25 46.672 	10.00 	.   
26 50.388 	10.08 	168 
27 46.080 	11.17 	156 
28 . 		8.92 	146 
29 39.203 	12.88 	168 
30 50.545 	9.93 	148 
31 47.920 	11.50 	170 
;

proc means noprint;
var oxygen runtime runpulse;
run;

proc corr nomiss noprint;
var oxygen runtime runpulse;
run;

title 'Regression Excluding Missing Data';
proc reg noprint;
model oxygen=runtime runpulse;
run;

title 'Multiple Imputation';
proc mi data=Fitness seed=37851 out=miout;
mcmc chain=single initial=em;
var Oxygen RunTime RunPulse;
run;

title 'Regression After Imputing Data';
proc reg data=miout outest=outreg covout;
model Oxygen= RunTime RunPulse;
by _Imputation_;
run;

title 'Mianalyze';
proc mianalyze data=outreg mult edf=28;
modeleffects Intercept RunTime RunPulse;
run;
