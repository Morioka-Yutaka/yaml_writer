/*** HELP START ***//*

Macro Name : yaml_start
Function   : Initialize YAML output. Define the output file,
              set up a global newline macro variable,
              and start PROC STREAM.
Parameters :
   - outpath= : Output directory path (default = current directory)
   - file=    : Output file name (".yaml" extension is automatically appended)

Example    :
%yaml_start(outpath=C:/tmp, file=sample);
#This YAML is a sample &nw.;
person: &nw.;
  name: Yutaka Morioka &nw.;
  age: 41 &nw.;
  height: 170 &nw.;
  weight: 63 &nw.;
%yaml_end();


*//*** HELP END ***/

%macro yaml_start(outpath=., file=sample);
filename sample "&outpath./&file..yaml";
%global nw;
%let nw=__ NEWLINE;
proc stream outfile=sample resetdelim="__";
begin
%mend;
