#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: Data2Services CWL workflow, Ammar Ammar <ammar257ammar@gmail.com> 


baseCommand: [docker, run]

arguments: [ "--rm", "--link","graphdb:graphdb", "-v" , "$(inputs.working_directory):/data", "-v", "$(runtime.outdir):/tmp", 
"vemonet/data2services-sparql-operations", "-op", "expand", "--expand-delete" ]

inputs:

  working_directory:
    type: string
  dataset:
    type: string
  sparql_triplestore_url:
    type: string
    inputBinding:
      position: 1
      prefix: -ep
  sparql_triplestore_repository:
    type: string
    inputBinding:
      position: 2
      prefix: -rep
  sparql_username:
    type: string?
    inputBinding:
      position: 3
      prefix: -un
  sparql_password:
    type: string?
    inputBinding:
      position: 4
      prefix: -pw
  expand_property:
    type: string
    inputBinding:
      position: 5
      prefix: --expand-property
  expand_class:
    type: string
    inputBinding:
      position: 6
      prefix: --expand-class
  expansion_uri:
    type: string
    inputBinding:
      position: 7
      prefix: --uri-expansion
  expansion_infer_prefix:
    type: string
    default: ","
    inputBinding:
      position: 8
      prefix: --infer-expansion-prefix


stdout: execute-expand-logs.txt

outputs:
  execute_expand_logs:
    type: stdout
