/*** HELP START ***//*

Macro Name : yaml_end
Function   : Finalize YAML output. Close the PROC STREAM block
              and complete writing to the output file.
Parameters : (none)

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

%macro yaml_end();
;;;;
run;
%mend;
