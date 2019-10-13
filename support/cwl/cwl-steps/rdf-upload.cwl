#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: Data2Services CWL workflow, Ammar Ammar <ammar257ammar@gmail.com> 


baseCommand: [docker, exec]

arguments: [ "-i", "virtuoso","bash", "-c", "cd /data && ./load.sh $(inputs.nquads_file.dirname) rdf_output.nq http://bio2rdf.org vload.log $(inputs.triple_store_password)"]

inputs:
  
  triple_store_username:
    type: string
  triple_store_password:
    type: string
  nquads_file:
    type: File

stdout: rdf-upload.txt

outputs:
  rdf_upload_logs:
    type: stdout
