#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

label: Data2Services CWL workflow to convert CSV/TSV files with statements split, Vincent Emonet <vincent.emonet@gmail.com> 


inputs: 
  
  working_directory: string 
  dataset: string

  download_username: string
  download_password: string
  
  input_data_jdbc: string

  sparql_base_uri: string
  sparql_tmp_graph_uri: string

  sparql_triplestore_url: string

  triple_store_username: string
  triple_store_password: string

  sparql_input_graph_uri: string

  sparql_transform_queries_path: string
  sparql_insert_metadata_path: string
  sparql_compute_hcls_path:
    type: string
    default: https://github.com/MaastrichtU-IDS/data2services-transform-repository/tree/master/sparql/compute-hcls-stats

 
outputs:
  
  download_dataset_logs:
    type: File
    outputSource: step1-d2s-download/download_dataset_logs
  xml2rdf_file_output:
    type: File
    outputSource: step2-xml2rdf/xml2rdf_file_output
  nquads_file_output:
    type: File
    outputSource: step2-xml2rdf/nquads_file_output
  rdf_upload_logs:
    type: File
    outputSource: step3-rdf-upload/rdf_upload_logs
  execute_sparql_metadata_logs:
    type: File
    outputSource: step4-insert-metadata/execute_sparql_query_logs
  execute_sparql_transform_logs:
    type: File
    outputSource: step5-execute-transform-queries/execute_sparql_query_logs
  execute_sparql_hcls_logs:
    type: File
    outputSource: step6-compute-hcls-stats/execute_sparql_query_logs

steps:

  step1-d2s-download:
    run: ../../cwl/cwl-steps/d2s-download.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      download_username: download_username
      download_password: download_password
    out: [download_dataset_logs]

  step2-xml2rdf:
    run: ../../cwl/cwl-steps/run-xml2rdf.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_tmp_graph_uri: sparql_tmp_graph_uri
      previous_step_results: step1-d2s-download/download_dataset_logs # TO REMOVE?
    out: [xml2rdf_file_output,nquads_file_output]

  step3-rdf-upload:
    run: ../../cwl/cwl-steps/rdf-upload.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      nquads_file: step2-xml2rdf/nquads_file_output
      sparql_triplestore_url: sparql_triplestore_url

    out: [rdf_upload_logs]

  step4-insert-metadata:
    run: ../../cwl/cwl-steps/execute-sparql-mapping.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_queries_path: sparql_insert_metadata_path
      sparql_triplestore_url: sparql_triplestore_url

      previous_step_results: step3-rdf-upload/rdf_upload_logs
    out: [execute_sparql_query_logs]
 
  step5-execute-transform-queries:
    run: ../../cwl/cwl-steps/execute-sparql-mapping.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_queries_path: sparql_transform_queries_path
      sparql_triplestore_url: sparql_triplestore_url

      previous_step_results: step3-rdf-upload/rdf_upload_logs      
    out: [execute_sparql_query_logs]

  step6-compute-hcls-stats:
    run: ../../cwl/cwl-steps/execute-sparql-mapping.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_queries_path: sparql_compute_hcls_path
      sparql_triplestore_url: sparql_triplestore_url

      sparql_input_graph_uri : sparql_input_graph_uri
      previous_step_results: step5-execute-transform-queries/execute_sparql_query_logs
    out: [execute_sparql_query_logs]

