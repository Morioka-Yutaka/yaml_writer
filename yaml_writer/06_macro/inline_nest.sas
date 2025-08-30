/*** HELP START ***//*

Macro Name : inline_nest
 Function   : Create a nested structure in **inline notation**
              (mapping or sequence) and store it as a new variable.
              This is useful when you want compact inline YAML/JSON-like
              representations rather than multi-line structures.
 Parameters :
   - key=       : Name of the new parent variable
                  (must not already exist in the dataset)
   - varlist=   : Variables to be nested under the key
   - cat=       : "mapping" or "sequence"
   - maxlength= : Length of the temporary character variable
                  (set large enough to avoid truncation)

Example    :
data class_inline;
   set sashelp.class;
   %inline_nest(key=HW_inline, varlist=HEIGHT WEIGHT, cat=mapping);
   %inline_nest(key=NAMEAGE_inline, varlist=NAME AGE, cat=sequence);
run;
%yaml_start()
class_inline: &nw.;
%dataset_export(ds=class_inline
             ,wh=%nrbquote(AGE in (13:15))
             ,cat=mappingsequence
             ,varlist=name HW_inline NAMEAGE_inline
             ,indent=1)
;;;;
%yaml_end();

*//*** HELP END ***/

%macro inline_nest(key=, varlist=, cat=mapping,maxlength=1000);
%let varlist=%sysfunc(compbl(&varlist));
%let varnum = %sysfunc( count( &varlist, %str ( ) ))+1;
%do i = 1 %to &varnum+1;
 %let var&i =  %sysfunc(scan( &varlist,&i, %str ( ) ));
%end;
length &key $&maxlength.;
%if %index(%lowcase(&cat),mapping) %then %do;
  %do i =1 %to &varnum;
	  &key=catx(", ",&key,catx(": ",vname(&&var&i),&&var&i));
	  %if &i = &varnum %then %do;&key=cats("{",&key,"}");%end;
  %end;
%end;
%if %index(%lowcase(&cat),sequence) %then %do;
 &key =cats("[",catx(", ",of &varlist),"]");
%end;
%mend;
