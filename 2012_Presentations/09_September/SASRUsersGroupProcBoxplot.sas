*Adapted from code found here: http://www2.sas.com/proceedings/sugi28/228-28.pdf;

proc print data=sashelp.heart; run;

proc freq data=sashelp.heart;
tables weight_status;
run;

data boxplot; set sashelp.heart;
where weight_status ne 'Underweight';
if sex='Female' and weight_status='Normal' then sexweight=1;
if sex='Female' and weight_status='Overweight' then sexweight=2;
if sex='Male' and weight_status='Normal' then sexweight=4;
if sex='Male' and weight_status='Overweight' then sexweight=5;
run;


proc format;
value boxgr
1= 'Normal Weight'
2= 'Overweight'
3= ' '
4= ' Normal Weight'
5= 'Overweight'
;
run;

*************************************************************************************************************************
Basic plot with the usual options
*************************************************************************************************************************;


data f; set boxplot;
format sexweight boxgr.;
run;

proc sort data=f;
by sexweight;
run;

goptions reset=all;
proc boxplot data=f;
plot cholesterol*sexweight
(sex) /
nohlabel
NPANELPOS=5 BLOCKPOS=2
CONTINUOUS
;
label cholesterol = 'Cholesterol Level';
run;
quit;



*************************************************************************************************************************
To remove the blue color from the boxplot, use cboxfill option
*************************************************************************************************************************;

goptions reset=all;
proc boxplot data=f;
plot cholesterol*sexweight
(sex) /
nohlabel
NPANELPOS=5 BLOCKPOS=2
CONTINUOUS
cboxfill=empty
;
label cholesterol = 'Cholesterol Level';
run;
quit;



*************************************************************************************************************************
To remove the blue color from the symbol indicating the mean (+), use symbol statement
*************************************************************************************************************************;

goptions reset=all;
proc boxplot data=f;
plot cholesterol*sexweight
(sex) /
nohlabel
NPANELPOS=5 BLOCKPOS=2
CONTINUOUS
cboxfill=empty
;
label cholesterol = 'Cholesterol Level';
symbol1 v=plus c=black;
run;
quit;



*************************************************************************************************************************
To make the blocking variable header white requires creating a color variable and using the cblockvar option
*************************************************************************************************************************;

data temp; set boxplot;
color_variable='white';
run;

data f; set temp;
format sexweight boxgr.;
run;

proc sort data=f;
by sexweight;
run;

goptions reset=all;
proc boxplot data=f;
plot cholesterol*sexweight
(sex) /
nohlabel
NPANELPOS=5 BLOCKPOS=2
CONTINUOUS
cboxfill=empty
cblockvar=color_variable
;
label cholesterol = 'Cholesterol Level';
symbol1 v=plus c=black;
run;
quit;



*************************************************************************************************************************
To make the font in the blocking variable header larger, use the height option (will change all font)
*************************************************************************************************************************;

goptions reset=all;
proc boxplot data=f;
plot cholesterol*sexweight
(sex) /
nohlabel
NPANELPOS=5 BLOCKPOS=2
CONTINUOUS
cboxfill=empty
cblockvar=color_variable
height=2.4
;
label cholesterol = 'Cholesterol Level';
symbol1 v=plus c=black;
run;
quit;



*************************************************************************************************************************
To output the file to a giff image add in the gsfname, dev, gsfmode, and filename options
-gsfname=outfile - tells SAS that the internal name for your image is outfile
-dev=gif - tells SAS to output the image to a gif file type
-gsfmode=replace - tells SAS that if you run the code again you want to replace the existing file
-filename outgfile "file_path_name\name_of_output_file.gif"- tells SAS the specific location and name of the output file

Note: you won't want to use this option if you want to do edit the image before saving
i.e. to center the labels in the blocking variable header
*************************************************************************************************************************;

goptions reset=all;
goptions gsfname=outgfile dev=gif gsfmode=replace;
filename outgfile
"C:\Users\sumougrad\Desktop\boxplot image.gif";
proc boxplot data=f;
plot cholesterol*sexweight
(sex) /
nohlabel
NPANELPOS=5 BLOCKPOS=2
CONTINUOUS
cboxfill=empty
cblockvar=color_variable
height=2.4
;
label cholesterol = 'Cholesterol Level';
symbol1 v=plus c=black;
run;
quit;
