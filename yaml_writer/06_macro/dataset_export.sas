/*** HELP START ***//*

Macro Name : dataset_export
Function   : Export a SAS dataset into YAML format.
              Designed in the same spirit as the "export" statement
              in PROC JSON.
 Parameters :
   - ds=       : Target SAS dataset
   - wh=       : (Optional) WHERE clause to filter observations
   - varlist=  : Variables to output, separated by spaces
   - indent=   : Indentation level (1 → 2 spaces, 2 → 4 spaces, …)
   - cat=      : Structure type
                   * mapping
                       Name: Alfred
                       Age: 14
                   * sequence
                       - Alfred
                       - 14
                   * mappingsequence
                       - Name: Alfred
                         Age: 14

Example    :
%yaml_start()
sashelp.class: &nw.;
%dataset_export(ds=sashelp.class
             ,wh=%nrbquote(AGE in (13:15))
             ,cat=mapping
             ,varlist=NAME AGE SEX
             ,indent=1)
;;;;
%yaml_end();

*//*** HELP END ***/

%macro dataset_export(ds=,wh= ,cat=mapping,varlist=,indent=1);
%local yobs;
%let varlist=%sysfunc(compbl(&varlist));
%let varnum = %sysfunc( count( &varlist, %str ( ) ))+1;
%do i = 1 %to &varnum+1;
 %local  var&i ;
 %let var&i =  %sysfunc(scan( &varlist,&i, %str ( ) ));
 %put &&var&i;
%end;
%macro dloop;
  %do i =1 %to &varnum;
	  call symput(cats("mvarname&i._",_N_),ksubstr(cat(repeat(" ",&indent * 2),vname(&&var&i)),2));
	  call symputx(cats("mvar&i._",_N_),&&var&i);
	  call symput(cats("mvarseq&i._",_N_),ksubstr(cat(repeat(" ",&indent * 2),"- ",&&var&i),2));
	  %if &i=1 %then %do;
		call symput(cats("mvarname_mapseq&i._",_N_),ksubstr(cat(repeat(" ",&indent * 2),"- ",vname(&&var&i)),2));
	  %end;
	  %else %do;
		call symput(cats("mvarname_mapseq&i._",_N_),ksubstr(cat(repeat(" ",&indent * 2 + 2),vname(&&var&i)),2));
	  %end;
  %end;
%mend;
%let _rc = %sysfunc(dosubl(%str(
data tmp;
 set &ds;
 where &wh;
run;
data _NULL_;
  if 0 then set tmp nobs=NOBS;
  call symputx("yobs", NOBS);
  stop;
run;
data _null_;
 set tmp;
 %dloop;
run;
)));
%do h=1 %to &yobs.;
 %do i = 1 %to &varnum;
   %if %index(%lowcase(&cat),mapping) and %index(%lowcase(&cat),sequence)  %then %do;
&&mvarname_mapseq&i._&h: &&mvar&i._&h &nw.;
  %end;
  %else %if %index(%lowcase(&cat),mapping) %then %do;
&&mvarname&i._&h: &&mvar&i._&h &nw.;
  %end;
  %else %if %index(%lowcase(&cat),sequence) %then %do;
&&mvarseq&i._&h &nw.;
  %end;
  %symdel mvar&i._&h mvarname&i._&h mvarseq&i._&h mvarname_mapseq&i._&h;
 %end;
%end;

%mend;
