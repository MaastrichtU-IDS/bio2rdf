#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

label: Data2Services CWL workflow to convert CSV/TSV files with statements split, Vincent Emonet <vincent.emonet@gmail.com> 


inputs: 
  
  working_directory: string 
  dataset: string

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
  r2rml_trig_file_output:
    type: File
    outputSource: step2-autor2rml/r2rml_trig_file_output
  r2rml_config_file_output:
    type: File
    outputSource: step3-generate-r2rml-config/r2rml_config_file_output
  nquads_file_output:
    type: File
    outputSource: step4-r2rml/nquads_file_output
  rdf_upload_logs:
    type: File
    outputSource: step5-rdf-upload/rdf_upload_logs
  execute_sparql_metadata_logs:
    type: File
    outputSource: step6-insert-metadata/execute_sparql_query_logs
  execute_sparql_transform_logs:
    type: File
    outputSource: step7-execute-transform-queries/execute_sparql_query_logs


steps:

  step1-d2s-download:
    run: ../../cwl/cwl-steps/d2s-download.cwl
    in:
      working_directory: working_directory
      dataset: dataset
    out: [download_dataset_logs]

  step2-autor2rml:
    run: ../../cwl/cwl-steps/autor2rml.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      input_data_jdbc: input_data_jdbc
      sparql_base_uri: sparql_base_uri
      sparql_tmp_graph_uri: sparql_tmp_graph_uri
      previous_step_results: step1-d2s-download/download_dataset_logs
    out: [r2rml_trig_file_output]

  step3-generate-r2rml-config:
    run: ../../cwl/cwl-steps/generate-r2rml-config.cwl
    in:
      dataset: dataset
      input_data_jdbc: input_data_jdbc
      r2rml_trig_file: step2-autor2rml/r2rml_trig_file_output
    out: [r2rml_config_file_output]

  step4-r2rml:
    run: ../../cwl/cwl-steps/run-r2rml.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      r2rml_trig_file: step2-autor2rml/r2rml_trig_file_output
      r2rml_config_file: step3-generate-r2rml-config/r2rml_config_file_output
    out: [nquads_file_output]


  step5-rdf-upload:
    run: ../../cwl/cwl-steps/rdf-upload.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      nquads_file: step4-r2rml/nquads_file_output
      sparql_triplestore_url: sparql_triplestore_url
      triple_store_password: triple_store_password
      triple_store_username: triple_store_username
    out: [rdf_upload_logs]

  step6-insert-metadata:
    run: ../../cwl/cwl-steps/execute-sparql-mapping.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_queries_path: sparql_insert_metadata_path
      sparql_triplestore_url: sparql_triplestore_url

      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_sparql_query_logs]

  step7-execute-transform-queries:
    run: ../../cwl/cwl-steps/execute-sparql-mapping.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_queries_path: sparql_transform_queries_path
      sparql_triplestore_url: sparql_triplestore_url

      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_sparql_query_logs]

  step8-compute-hcls-stats:
    run: ../../cwl/cwl-steps/execute-sparql-mapping.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_queries_path: sparql_compute_hcls_path
      sparql_triplestore_url: sparql_triplestore_url

      sparql_input_graph_uri : sparql_input_graph_uri
      previous_step_results: step7-execute-transform-queries/execute_sparql_query_logs
    out: [execute_sparql_query_logs]
