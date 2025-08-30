Type : Package
Package : yaml_writer
Title : yaml_writer
Version : 0.1.0
Author : Yutaka Morioka(sasyupi@gmail.com)
Maintainer : Yutaka Morioka(sasyupi@gmail.com)
License : MIT
Encoding : UTF8
Required : "Base SAS Software"
ReqPackages :  

DESCRIPTION START:
Overall Usage Guide

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
DESCRIPTION END:
