#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: Data2Services CWL workflow, Ammar Ammar <ammar257ammar@gmail.com> 


baseCommand: [docker, run]

arguments: [ "--rm", "-v" , "$(inputs.working_directory)/input:/data", "-v", "$(runtime.outdir):/tmp", 
"vemonet/data2services-download", "--download-datasets", "$(inputs.dataset)"]

inputs:
  
  working_directory:
    type: string
  dataset:
    type: string
  download_username:
    type: string?
    inputBinding:
      position: 1
      prefix: --username
  download_password:
    type: string?
    inputBinding:
      position: 2
      prefix: --password

stdout: download-dataset.txt

outputs:
  download_dataset_logs:
    type: stdout
