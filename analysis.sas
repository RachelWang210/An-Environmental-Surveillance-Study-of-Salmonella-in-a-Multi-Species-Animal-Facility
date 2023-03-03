/*import data*/

FILENAME REFFILE '/home/zzw00490/7250/Environmental Project Compiled Information 2013-2016.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX replace
	OUT=S1;
	Sheet='2014';
	GETNAMES=YES;
RUN;
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX replace
	OUT=S2;
	Sheet='2015';
	GETNAMES=YES;
RUN;
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX replace
	OUT=S3;
	Sheet='2016';
	GETNAMES=YES;
RUN;

/*merge data*/
data s;
 set s1 s2 s3;
run;
data s4;
 set s;
 if year='' then delete;
 if year='One' then year=1;
 if year='Two' then year=2;
 if year='Thr' then year=3;
 if Salmonella_Positive='Yes' then Salmonella=1; else Salmonella=0;
 drop water_source o Salmonella_Positive method;
run;
proc print data=s4; run;


/*regular logistic regression*/
proc logistic data = s4 descending;
   class Season Facility Region Species Condition Environment Sample_Method;
   model salmonella= Humidity Temp Season Facility Region Species Condition Environment Sample_Method ;
run;

/*glimmix*/
proc glimmix data=s4;
 class Season Facility Region Species Condition Environment Sample_Method;
 model salmonella= Humidity Temp Season Facility Region Species Condition Environment Sample_Method;
run; quit;

/*glimmix with random effect*/
proc glimmix data=s4;
 class Season Facility Region Species Condition Environment Sample_Method;
 model salmonella= Humidity Temp Season Facility Region Species Condition Environment Sample_Method;
 random region(facility);
run; quit;



