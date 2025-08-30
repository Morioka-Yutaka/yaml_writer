# yaml_writer
A lightweight SAS macro package to generate YAML files directly from SAS.  
It lets you:  
・Start and end YAML output streams  
・Export datasets into YAML (mapping, sequence, mappingsequence)  
・Build nested or inline structures  
Write YAML directly between %yaml_start and %yaml_end,  
use &nw. for line breaks, and %dataset_export / %nest / %inline_nest for structured output.  
<img width="423" height="458" alt="Image" src="https://github.com/user-attachments/assets/89ce11e5-62b2-4655-9075-b06b349f6ab6" />

#Overall Usage Guide

This macro toolkit provides a way to generate YAML directly from SAS.
The workflow is simple:

[1] Wrap YAML output between %yaml_start and %yaml_end.
Everything written between these two macros will be streamed to the output file.

[2] Use &nw. to insert line breaks.
Since PROC STREAM is used internally, &nw. acts as the newline marker.

[3] Write YAML manually or generate it from datasets.
 - You can directly type YAML key–value pairs between %yaml_start and %yaml_end.
- To automatically export dataset content into YAML structures, use %dataset_export.
- This converts dataset observations and variables into mapping/sequence/mappingsequence formats.

[4] For hierarchical YAML structures, preprocess the dataset first.
- Use %nest when you want to create multi-line nested structures (mapping or sequence).
- Use %inline_nest when you want compact inline structures ({} for mappings or [] for sequences).
- After preprocessing, pass the new nested variables into %dataset_export.

## `%yaml_start()` macro <a name="yamlstart-macro-5"></a> ######
Function   : Initialize YAML output. Define the output file,  
              set up a global newline macro variable,  
              and start PROC STREAM.  
Parameters :  
~~~text
   - outpath= : Output directory path (default = current directory)
   - file=    : Output file name (".yaml" extension is automatically appended)
~~~
Example    :  
~~~sas
%yaml_start(outpath=C:/tmp, file=sample);
#This YAML is a sample &nw.;
person: &nw.;
  name: Yutaka Morioka &nw.;
  age: 41 &nw.;
  height: 170 &nw.;
  weight: 63 &nw.;
%yaml_end();
~~~

  
---

