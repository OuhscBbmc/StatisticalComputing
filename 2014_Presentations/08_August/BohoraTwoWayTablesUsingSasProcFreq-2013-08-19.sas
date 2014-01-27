*** OKSUG/SCUG presentaton by Som Bohora ***
*** Date : 80/19/2013 ********************;
*** Two-way table to compare the probability of coronary heart disease for two types of diet.***
*** Reference: http://support.sas.com/documentation/cdl/en/procstat/63104/HTML/default/viewer.htm#procstat_freq_sect029.htm***;

*Creating data set;
data diet;	
input exposure response;
datalines;
0	0
0	0
0	0
0	0
0	0
0	0
0	1
0	1
1	0
1	0
1	0
1	0
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
;
run;
proc print data=diet; run;

proc format; *Creating format for levels of exposure and response;
	value expf 1 = "High"
			   0 = "Low";
	value resf 1 = "Yes"
			   0 = "No";
run;

proc freq data=diet; *Running FREQ procedure;
title 'Case-control study of High Fat/cholesterol diet';
	format exposure expf. response resf.;
	tables exposure*response;
run;

* How you want to input if you are given only following four numbers corresponding 
to exposure and response so that you can run FREQ procedure;
**********************************
		      response	
		       1  0
exposure   1  11  4
		   0   2  6
**********************************;

data diet_wt; *Input the counts to create a data set. Count contains frequencies for each exposure and response combination;
	input exposure response count;
datalines;
1 1 11
1 0  4
0 1  2
0 0  6
;
run;

proc freq data=diet_wt;
title 'Case-control study of High Fat/cholesterol diet';
	format exposure expf. response resf.;
	tables exposure*response;
	weight count;
run;

proc sort data=diet; by descending response;  *Default sorting is ascending;
Title'Sorting diet_wt data set in descending order by response variable';
run;

ods rtf file="freq.rtf";

*Tables requests two-way table for exposure by response variable. Exposure is row and respnse is column variable.
ORDER=DATA option orders the contingency table values by their order in the input data set;

*** Exposure/treatment in Row***;
proc freq data=diet_wt order=data;
title 'Case-control study of High Fat/cholesterol diet';
	format exposure expf. response resf.;
	weight count;
	tables exposure*response / nocol nopercent measures; 
run;

*** Exposure/treatment in Column***;
proc freq data=diet_wt order=data;
title 'Case-control study of High Fat/cholesterol diet';
	format exposure expf. response resf.;
	weight count;
	tables response*exposure / norow nopercent measures; 
run;

ods rtf close;

****SAS certification program: http://support.sas.com/certify/index.html****




