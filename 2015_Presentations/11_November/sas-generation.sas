****  Program 4.6 SAS Macro for Generating Correlated Normal Variables (Any Number)  ****;

/*----------------------------------------------------------------------------*/
/* Macro RMNC generates Random variables of Multivariate Normal distribution  */
/* with given means, standard deviations and Correlation matrix.              */
/*                                                                            */
/* Parameters                                                                 */
/* DATA       the name of the input file that determines the characteristics  */
/*            of the random numbers to be generated. The file specifies       */
/*            the mean, standard deviation, number of observations of each    */
/*            random number and the correlation coefficients between the      */
/*            variables. It must be a TYPE=CORR file and its structure must   */
/*            comply with that of such file (see e.g. 'Chapter 15: The CORR   */
/*            Procedure' in SAS Procedure Guides, Version 3): The file has    */
/*            to have the following and only the following observations:      */
/*            _TYPE_=MEAN, STD, N, CORR. Its variables are _TYPE_, _NAME_ and */
/*            the variables to be generated. If the number of observations    */
/*            is not the same for all variables, the macro takes the minimum  */
/*            number of observations for all random variables.                */
/* OUT        the name of the output file that has the random variables       */
/*            generated according to the file given in parameter DATA.        */
/* SEED       seed of the random number generator.                            */
/*                                                                            */
/* Example                                                                    */
/* The code below sets up an input file, calls the macro to request three     */
/* random variables, and it checks their distributions and correlation        */
/* matrix.                                                                    */
/*                                                                            */
/*     data a(type=corr);                                                     */
/*          input _name_ $ _type_ $ x1-x3;                                    */
/*          cards;                                                            */
/*      .   MEAN    100     50      0                                         */
/*      .   STD      15     10      1                                         */
/*      .   N     10000  10000  10000                                         */
/*      x1  CORR   1.00      .      .                                         */
/*      x2  CORR    .70   1.00      .                                         */
/*      x3  CORR    .20    .40   1.00                                         */
/*      ;                                                                     */
/*          run;                                                              */
/*     %rmnc(data=a,out=b,seed=123)                                           */
/*     proc means data=b n mean std skewness kurtosis maxdec=2;               */
/*     proc corr data=b;                                                      */
/*          var x1-x3;                                                        */
/*          run;                                                              */
/*                                                                            */
/* Output of Example                                                          */
/* Variable Label                             N   Mean Std Dev  Skewn.  Kurt. */
/* -------------------------------------------------------------------------- */
/* X1       St.Normal Var., m=100, std=15 10000  99.99   14.93    0.02  -0.01 */
/* X2       St.Normal Var., m=50, std=10  10000  50.04    9.95    0.02  -0.04 */
/* X3       St.Normal Var., m=0, std=1    10000  -0.01    1.00   -0.01  -0.06 */
/* -------------------------------------------------------------------------- */
/*                                                                            */
/* Pearson Correlation Coefficients / Prob > |R| under Ho: Rho=0 / N = 10000  */
/*                                                                            */
/*                                        X1          X2          X3          */
/*                                                                            */
/* X1                                1.00000     0.70462     0.20305          */
/* St.Normal Var., m=100, std=15      0.0         0.0001      0.0001          */
/*                                                                            */
/* X2                                0.70462     1.00000     0.39276          */
/* St.Normal Var., m=50, std=10       0.0001      0.0         0.0001          */
/*                                                                            */
/* X3                                0.20305     0.39276     1.00000          */
/* St.Normal Var., m=0, std=1         0.0001      0.0001      0.0             */
/*                                                                            */
/*----------------------------------------------------------------------------*/
data a(type=corr);                                                      
      input _name_ $ _type_ $ x1-x3;                                    
      cards;                                                             
  .   MEAN    100     50      0                                         
  .   STD      15     10      1                                          
  .   N     10000  10000  10000                                          
  x1  CORR   1.00      .      .                                         
  x2  CORR    .70   1.00      .                                          
  x3  CORR    .20    .40   1.00                                           
run;  

/*Remember to highlight the macro and the run together when you run the sas)*/
%MACRO RMNC (DATA=,OUT=,SEED=0);

  /* obtain the names of the random variables to be generated. */
  /* the names are stored in macro variables V1, V2,...        */
  /* macro variable VNAMES has all these variable names        */
  /* concatenated into one long string.                        */

  PROC CONTENTS DATA=&DATA(DROP=_TYPE_ _NAME_) OUT=_DATA_(KEEP=NAME) NOPRINT;
       RUN;
  DATA _DATA_;
       SET _LAST_ END=END;
       RETAIN N 0;
       N=N+1;
       V=COMPRESS('V'||COMPRESS(PUT(N,6.0)));
       CALL SYMPUT(V,NAME);
       IF END THEN CALL SYMPUT('NV',LEFT(PUT(N,6.)));
       RUN;
  %LET VNAMES=&V1;
  %DO I=2 %TO &NV;
      %LET VNAMES=&VNAMES &&V&I;
  %END;


  /* obtain the matrix of factor patterns and other statistics. */

  PROC FACTOR DATA=&DATA NFACT=&NV NOPRINT
              OUTSTAT=_PTTRN_(WHERE=(_TYPE_ IN ('MEAN','STD','N','PATTERN')));
       RUN;

  /* generate the random numbers.*/

  %LET NV2=%EVAL(&NV*&NV);
  DATA &OUT(KEEP=&VNAMES);

       /* rename the variables to be generated to V1, V2,... in order */
       /* to avoid any interference with the data step variables.     */

       SET _PTTRN_(KEEP=&VNAMES _TYPE_ RENAME=(          %DO I=1 %TO &NV;
                                               &&V&I=V&I
                                                         %END;
                                                        )) END=LASTFACT;
       RETAIN;

       /* set up arrays to store the necessary statistics. */

       ARRAY FPATTERN(&NV,&NV) F1-F&NV2;  /* factor pattern                   */
       ARRAY VMEAN(&NV)        M1-M&NV;   /* mean                             */
       ARRAY VSTD(&NV)         S1-S&NV;   /* standard deviation               */
       ARRAY V(&NV)            V1-V&NV;   /* random variables to be generated */
       ARRAY VTEMP(&NV)        VT1-VT&NV; /* temporary variables              */
       LENGTH LBL $40;

       /* read and store the matrix of factor patterns. */

       IF _TYPE_='PATTERN' THEN DO; DO I=1 TO &NV;

                                       /* here we utilize the fact that the  */
                                       /* observations of the factor pattern */
                                       /* start at observation #4.           */

                                       FPATTERN(_N_-3,I)=V(I);
                                    END;
                                END;

       /* read and store the means. */

       IF _TYPE_='MEAN' THEN DO; DO I=1 TO &NV;
                                    VMEAN(I)=V(I);
                                 END;
                             END;

       /* read and store the standard deviations. */

       IF _TYPE_='STD' THEN DO; DO I=1 TO &NV;
                                   VSTD(I)=V(I);
                                END;
                            END;

       /* read and store the number of observations. */

       IF _TYPE_='N' THEN NNUMBERS=V(1);

       /* all necessary statistics have been read and stored. */
       /* start generating the random numbers.                */

       IF LASTFACT THEN DO;

          /* set up labels for the random variables. The labels */
          /* are stored in macro variables LBL1, LBL2,... and   */
          /* used in the subsequent PROC DATASETS.              */

          %DO I=1 %TO &NV;
              LBL="ST.NORMAL VAR., M="||COMPRESS(PUT(VMEAN(&I),BEST8.))||
                  ", STD="||COMPRESS(PUT(VSTD(&I), BEST8.));
              CALL SYMPUT("LBL&I",LBL);
          %END;

          DO K=1 TO NNUMBERS;

             /* generate the initial random numbers of standard   */
             /* normal distribution. Store them in array 'VTEMP.' */

             DO I=1 TO &NV;
                VTEMP(I)=RANNOR(&SEED);
             END;

             /* impose the intercorrelation on each variable. The */
             /* transformed variables are stored in array 'V'.    */

             DO I=1 TO &NV;
                V(I)=0;
                DO J=1 TO &NV;
                   V(I)=V(I)+VTEMP(J)*FPATTERN(J,I);
                END;
             END;

             /* transform the random variables so they will have */
             /* means and standard deviations as requested.      */

             DO I=1 TO &NV;
                V(I)=VSTD(I)*V(I)+VMEAN(I);
             END;
             OUTPUT;
          END;
       END;

       /* rename V1,V2,... to the requested variable names. */

       RENAME           %DO I=1 %TO &NV;
              V&I=&&V&I
                        %END;
              ;
       RUN;

  /* set the label of each random variable. The label contains */
  /* the mean and standard deviation of the variable.          */

  PROC DATASETS NOLIST;
       MODIFY &OUT;
       LABEL %DO I=1 %TO &NV;
                 &&V&I="&&LBL&I"
             %END;
             ;
       RUN;
%MEND;
*************************************************************;
%RMNC(data=a,out=b,seed=123);
run;
