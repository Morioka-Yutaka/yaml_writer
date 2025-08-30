# yaml_writer
A lightweight SAS macro package to generate YAML files directly from SAS.
It lets you:
・Start and end YAML output streams
・Export datasets into YAML (mapping, sequence, mappingsequence)
・Build nested or inline structures
Write YAML directly between %yaml_start and %yaml_end,
use &nw. for line breaks, and %dataset_export / %nest / %inline_nest for structured output.
<img width="423" height="458" alt="Image" src="https://github.com/user-attachments/assets/89ce11e5-62b2-4655-9075-b06b349f6ab6" />
