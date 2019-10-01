#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: Data2Services CWL workflow, Ammar Ammar <ammar257ammar@gmail.com> 

baseCommand: [docker, run]

arguments: [ "--rm", "-v" , "$(inputs.working_directory):/data", "-v", "$(runtime.outdir):/tmp", 
"vemonet/xml2rdf:bio2rdf5", "-i", "/data/input/$(inputs.dataset)/*.xml", "-o", "/tmp/rdf_output.nq"]

requirements:
  EnvVarRequirement:
    envDef:
      HOME: $(inputs.working_directory)

inputs:
  
  working_directory:
    type: string
  dataset:
    type: string
  sparql_tmp_graph_uri:
    type: string
    default: https://w3id.org/data2services/graph/xml2rdf
    inputBinding:
      position: 3
      prefix: -g

stdout: xml2rdf_file_structure.txt

outputs:
  xml2rdf_file_output:
    type: stdout
  nquads_file_output:
    type: File
    outputBinding:
      glob: rdf_output.nq
