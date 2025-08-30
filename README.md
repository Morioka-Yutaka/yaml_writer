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
Function   : Initialize YAML output. Define the output file, set up a global newline macro variable, and start PROC STREAM.  
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

<img width="242" height="130" alt="Image" src="https://github.com/user-attachments/assets/40f096d9-e85a-47a3-9ee2-a7a8e46a185e" />
  
---


## `%yaml_end()` macro <a name="yamlend-macro-4"></a> ######
Function   : Finalize YAML output. Close the PROC STREAM block and complete writing to the output file.
Parameters : (none)  
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

<img width="242" height="130" alt="Image" src="https://github.com/user-attachments/assets/40f096d9-e85a-47a3-9ee2-a7a8e46a185e" />
  
---

## `%dataset_export()` macro <a name="datasetexport-macro-1"></a> ######
Function   : Export a SAS dataset into YAML format.  
              Designed in the same spirit as the "export" statement in PROC JSON.  
 Parameters :  
 ~~~text
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
~~~

Example    :  
~~~
%yaml_start()
sashelp.class: &nw.;
%dataset_export(ds=sashelp.class
             ,wh=%nrbquote(AGE in (13:15))
             ,cat=mapping
             ,varlist=NAME AGE SEX
             ,indent=1)
;;;;
%yaml_end();
~~~

<img width="310" height="634" alt="Image" src="https://github.com/user-attachments/assets/e7048bc0-7535-4da3-adb0-43646016c10d" />

  
---

## `%nest()` macro <a name="nest-macro-3"></a> ######
 Function   : Create nested structures in preparation for YAML output.  
              A new parent variable (key) is created that contains child variables as either a mapping or a sequence.
 Parameters :  
 ~~~text
   - key=       : Name of the new parent variable (must not exist already)
   - varlist=   : Variables to be nested under the key
   - cat=       : "mapping" or "sequence"
   - indent=    : Indentation level within the YAML structure
   - maxlength= : Length of the temporary character variable
                  (set large enough to avoid truncation)
~~~
Example    :  
~~~sas
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
~~~

<img width="301" height="740" alt="Image" src="https://github.com/user-attachments/assets/17b13bc2-5958-4de6-a3fb-b89076810ef6" />

---

## `%inline_nest()` macro <a name="inlinenest-macro-2"></a> ######
 Function   : Create a nested structure in **inline notation**  
              (mapping or sequence) and store it as a new variable.  
              This is useful when you want compact inline YAML/JSON-like representations rather than multi-line structures.
 Parameters :  
 ~~~text
   - key=       : Name of the new parent variable
                  (must not already exist in the dataset)
   - varlist=   : Variables to be nested under the key
   - cat=       : "mapping" or "sequence"
   - maxlength= : Length of the temporary character variable
                  (set large enough to avoid truncation)
~~~
Example    :  
~~~sas
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
~~~

<img width="530" height="632" alt="Image" src="https://github.com/user-attachments/assets/97e4540a-7022-4202-9a38-8306f97f13c8" />

---

## Notes on versions history

- 0.1.0(31August2025): Initial version.

---

## What is SAS Packages?

The package is built on top of **SAS Packages Framework(SPF)** developed by Bartosz Jablonski.

For more information about the framework, see [SAS Packages Framework](https://github.com/yabwon/SAS_PACKAGES).

You can also find more SAS Packages (SASPacs) in the [SAS Packages Archive(SASPAC)](https://github.com/SASPAC).

## How to use SAS Packages? (quick start)

### 1. Set-up SAS Packages Framework

First, create a directory for your packages and assign a `packages` fileref to it.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
filename packages "\path\to\your\packages";
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Secondly, enable the SAS Packages Framework.
(If you don't have SAS Packages Framework installed, follow the instruction in 
[SPF documentation](https://github.com/yabwon/SAS_PACKAGES/tree/main/SPF/Documentation) 
to install SAS Packages Framework.)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%include packages(SPFinit.sas)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### 2. Install SAS package

Install SAS package you want to use with the SPF's `%installPackage()` macro.

- For packages located in **SAS Packages Archive(SASPAC)** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located in **PharmaForest** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, mirror=PharmaForest)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located at some network location run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, sourcePath=https://some/internet/location/for/packages)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  (e.g. `%installPackage(ABC, sourcePath=https://github.com/SomeRepo/ABC/raw/main/)`)


### 3. Load SAS package

Load SAS package you want to use with the SPF's `%loadPackage()` macro.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%loadPackage(packageName)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### Enjoy!
