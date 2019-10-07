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
  sparql_triplestore_repository: string

  sparql_transform_queries_path: string
  sparql_insert_metadata_path: string
  sparql_compute_hcls_path:
    type: string
    default: https://github.com/MaastrichtU-IDS/data2services-transform-repository/tree/master/sparql/compute-hcls-stats

  split_property_0: string
  split_class_0: string
  split_delimiter_0: string


  split_property_1: string
  split_class_1: string
  split_delimiter_1: string
  split_quote_1: string

  split_property_2: string
  split_class_2: string
  split_delimiter_2: string


  split_property_3: string
  split_class_3: string
  split_delimiter_3: string
  split_quote_3: string

  split_property_4: string
  split_class_4: string
  split_delimiter_4: string


  split_property_5: string
  split_class_5: string
  split_delimiter_5: string


  split_property_6: string
  split_class_6: string
  split_delimiter_6: string


  split_property_7: string
  split_class_7: string
  split_delimiter_7: string


  split_property_8: string
  split_class_8: string
  split_delimiter_8: string


  split_property_9: string
  split_class_9: string
  split_delimiter_9: string
  split_quote_9: string

  split_property_10: string
  split_class_10: string
  split_delimiter_10: string


  split_property_11: string
  split_class_11: string
  split_delimiter_11: string


  split_property_12: string
  split_class_12: string
  split_delimiter_12: string


  split_property_13: string
  split_class_13: string
  split_delimiter_13: string

  split_property_14: string
  split_class_14: string
  split_delimiter_14: string

  split_property_15: string
  split_class_15: string
  split_delimiter_15: string


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
  execute_split_logs:
    type: File
    outputSource: step800-split/execute_split_logs
  execute_sparql_transform_logs:
    type: File
    outputSource: step7-execute-transform-queries/execute_sparql_query_logs
  execute_sparql_hcls_logs:
    type: File
    outputSource: step9-compute-hcls-stats/execute_sparql_query_logs


steps:

  step1-d2s-download:
    run: ../cwl/cwl-steps/d2s-download.cwl
    in:
      working_directory: working_directory
      dataset: dataset
    out: [download_dataset_logs]

  step2-autor2rml:
    run: ../cwl/cwl-steps/autor2rml.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      input_data_jdbc: input_data_jdbc
      sparql_base_uri: sparql_base_uri
      sparql_tmp_graph_uri: sparql_tmp_graph_uri
      previous_step_results: step1-d2s-download/download_dataset_logs
    out: [r2rml_trig_file_output]

  step3-generate-r2rml-config:
    run: ../cwl/cwl-steps/generate-r2rml-config.cwl
    in:
      dataset: dataset
      input_data_jdbc: input_data_jdbc
      r2rml_trig_file: step2-autor2rml/r2rml_trig_file_output
    out: [r2rml_config_file_output]

  step4-r2rml:
    run: ../cwl/cwl-steps/run-r2rml.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      r2rml_trig_file: step2-autor2rml/r2rml_trig_file_output
      r2rml_config_file: step3-generate-r2rml-config/r2rml_config_file_output
    out: [nquads_file_output]


  step5-rdf-upload:
    run: ../cwl/cwl-steps/rdf-upload.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      nquads_file: step4-r2rml/nquads_file_output
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
    out: [rdf_upload_logs]

  step6-insert-metadata:
    run: ../cwl/cwl-steps/execute-sparql-mapping.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_queries_path: sparql_insert_metadata_path
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_sparql_query_logs]

  step800-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_0
      split_class: split_class_0
      split_property: split_property_0
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step801-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_1
      split_quote: split_quote_1
      split_class: split_class_1
      split_property: split_property_1
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step802-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_2
      split_class: split_class_2
      split_property: split_property_2
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step803-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_3
      split_quote: split_quote_3
      split_class: split_class_3
      split_property: split_property_3
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step804-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_4
      split_class: split_class_4
      split_property: split_property_4
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step805-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_5
      split_class: split_class_5
      split_property: split_property_5
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step806-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_6
      split_class: split_class_6
      split_property: split_property_6
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step807-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_7
      split_class: split_class_7
      split_property: split_property_7
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step808-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_8
      split_class: split_class_8
      split_property: split_property_8
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step809-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_9
      split_quote: split_quote_9
      split_class: split_class_9
      split_property: split_property_9
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step810-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_10
      split_class: split_class_10
      split_property: split_property_10
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step811-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_11
      split_class: split_class_11
      split_property: split_property_11
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step812-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_12
      split_class: split_class_12
      split_property: split_property_12
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step813-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_13
      split_class: split_class_13
      split_property: split_property_13
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step814-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_14
      split_class: split_class_14
      split_property: split_property_14
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step815-split:
    run: ../cwl/cwl-steps/run-split.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_delimiter: split_delimiter_15
      split_class: split_class_15
      split_property: split_property_15
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step7-execute-transform-queries:
    run: ../cwl/cwl-steps/execute-sparql-mapping.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_queries_path: sparql_transform_queries_path
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      previous_step_results_0: step800-split/execute_split_logs
      previous_step_results_1: step801-split/execute_split_logs
      previous_step_results_2: step802-split/execute_split_logs
      previous_step_results_3: step803-split/execute_split_logs
      previous_step_results_4: step804-split/execute_split_logs
      previous_step_results_5: step805-split/execute_split_logs
      previous_step_results_6: step806-split/execute_split_logs
      previous_step_results_7: step807-split/execute_split_logs
      previous_step_results_8: step808-split/execute_split_logs
      previous_step_results_9: step809-split/execute_split_logs
      previous_step_results_10: step810-split/execute_split_logs
      previous_step_results_11: step811-split/execute_split_logs
      previous_step_results_12: step812-split/execute_split_logs
      previous_step_results_13: step813-split/execute_split_logs
      previous_step_results_14: step814-split/execute_split_logs
      previous_step_results_15: step815-split/execute_split_logs
    out: [execute_sparql_query_logs]

  step9-compute-hcls-stats:
    run: ../cwl/cwl-steps/execute-sparql-mapping.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_queries_path: sparql_compute_hcls_path
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      previous_step_results: step7-execute-transform-queries/execute_sparql_query_logs
    out: [execute_sparql_query_logs]
