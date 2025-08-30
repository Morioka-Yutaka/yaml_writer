/*** HELP START ***//*

Macro Name : nest
 Function   : Create nested structures in preparation for YAML output.
              A new parent variable (key) is created that contains
              child variables as either a mapping or a sequence.
 Parameters :
   - key=       : Name of the new parent variable (must not exist already)
   - varlist=   : Variables to be nested under the key
   - cat=       : "mapping" or "sequence"
   - indent=    : Indentation level within the YAML structure
   - maxlength= : Length of the temporary character variable
                  (set large enough to avoid truncation)

Example    :
data class_1;
  set sashelp.class;
   %nest(key=HW,   varlist=HEIGHT WEIGHT, cat=mapping, indent=3);
   %nest(key=AHHW, varlist=AGE HW,        cat=mapping, indent=2);
run;
%yaml_start()
class_1: &nw.;
%dataset_export(ds=class_1
             ,wh=%nrbquote(AGE in (13:15))
             ,cat=mappingsequence
             ,varlist=name HW AHHW
             ,indent=1)
;;;;
%yaml_end();

*//*** HELP END ***/

%macro nest(key=, varlist=, cat=mapping,indent=1,maxlength=1000);
%let varlist=%sysfunc(compbl(&varlist));
%let varnum = %sysfunc( count( &varlist, %str ( ) ))+1;
%do i = 1 %to &varnum+1;
 %let var&i =  %sysfunc(scan( &varlist,&i, %str ( ) ));
%end;
length &key $&maxlength.;
%if %index(%lowcase(&cat),mapping) %then %do;
  %do i =1 %to &varnum;
	  &key=catx(cat(" &nw;",repeat(" ",&indent * 2+2)),&key,catx(": ",vname(&&var&i),&&var&i));
	  %if &i = &varnum %then %do;&key=cat(" &nw;",repeat(" ",&indent * 2+2),&key);%end;
  %end;
%end;
%if %index(%lowcase(&cat),sequence) %then %do;
  %do i =1 %to &varnum;
	  &key=catx(cat(" &nw;",repeat(" ",&indent * 2+2)),&key,cat("- ",&&var&i));
	  %if &i = &varnum %then %do;&key=cat(" &nw;",repeat(" ",&indent * 2+2),&key);%end;
  %end;%end;
%mend;
