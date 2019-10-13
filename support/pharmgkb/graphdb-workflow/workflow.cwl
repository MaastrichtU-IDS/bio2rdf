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

  sparql_input_graph_uri: string

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

  split_property_2: string
  split_class_2: string
  split_delimiter_2: string

  split_property_3: string
  split_class_3: string
  split_delimiter_3: string

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

  split_property_16: string
  split_class_16: string
  split_delimiter_16: string

  split_property_17: string
  split_class_17: string
  split_delimiter_17: string


  split_property_18: string
  split_class_18: string
  split_delimiter_18: string

  split_property_19: string
  split_class_19: string
  split_delimiter_19: string

  split_property_20: string
  split_class_20: string
  split_delimiter_20: string



  split_property_21: string
  split_class_21: string
  split_delimiter_21: string

  split_property_22: string
  split_class_22: string
  split_delimiter_22: string

  split_property_23: string
  split_class_23: string
  split_delimiter_23: string

  split_property_24: string
  split_class_24: string
  split_delimiter_24: string



  split_property_25: string
  split_class_25: string
  split_delimiter_25: string

  split_property_26: string
  split_class_26: string
  split_delimiter_26: string

  split_property_27: string
  split_class_27: string
  split_delimiter_27: string

  split_property_28: string
  split_class_28: string
  split_delimiter_28: string

  split_property_29: string
  split_class_29: string
  split_delimiter_29: string

  split_property_30: string
  split_class_30: string
  split_delimiter_30: string

  split_property_31: string
  split_class_31: string
  split_delimiter_31: string

  split_property_32: string
  split_class_32: string
  split_delimiter_32: string



  split_property_33: string
  split_class_33: string
  split_delimiter_33: string

  split_property_34: string
  split_class_34: string
  split_delimiter_34: string

  split_property_35: string
  split_class_35: string
  split_delimiter_35: string

  split_property_36: string
  split_class_36: string
  split_delimiter_36: string


  split_property_37: string
  split_class_37: string
  split_delimiter_37: string

  split_property_38: string
  split_class_38: string
  split_delimiter_38: string

  split_property_39: string
  split_class_39: string
  split_delimiter_39: string

  split_property_40: string
  split_class_40: string
  split_delimiter_40: string



  split_property_41: string
  split_class_41: string
  split_delimiter_41: string

  split_property_42: string
  split_class_42: string
  split_delimiter_42: string

  split_property_43: string
  split_class_43: string
  split_delimiter_43: string

  split_property_44: string
  split_class_44: string
  split_delimiter_44: string

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
    outputSource: step700-split/execute_split_logs
  execute_sparql_transform_logs:
    type: File
    outputSource: step8-execute-transform-queries/execute_sparql_query_logs


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
    run: ../../cwl/cwl-steps/rdf-upload-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      nquads_file: step4-r2rml/nquads_file_output
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
    out: [rdf_upload_logs]

  step6-insert-metadata:
    run: ../../cwl/cwl-steps/execute-sparql-mapping-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_queries_path: sparql_insert_metadata_path
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_sparql_query_logs]

  step700-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property:  split_property_0
      split_class: split_class_0
      split_delimiter: split_delimiter_0
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step701-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_1
      split_class: split_class_1
      split_delimiter: split_delimiter_1
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step702-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_2
      split_class: split_class_2
      split_delimiter: split_delimiter_2
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step703-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_3
      split_class: split_class_3
      split_delimiter: split_delimiter_3
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step704-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_4
      split_class: split_class_4
      split_delimiter: split_delimiter_4
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step705-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_5
      split_class: split_class_5
      split_delimiter: split_delimiter_5
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step706-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_6
      split_class: split_class_6
      split_delimiter: split_delimiter_6
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step707-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_7
      split_class: split_class_7
      split_delimiter: split_delimiter_7
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step708-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_8
      split_class: split_class_8
      split_delimiter: split_delimiter_8
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step709-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_9
      split_class: split_class_9
      split_delimiter: split_delimiter_9
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step710-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_10
      split_class: split_class_10
      split_delimiter: split_delimiter_10
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step711-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_11
      split_class: split_class_11
      split_delimiter: split_delimiter_11
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step712-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_12
      split_class: split_class_12
      split_delimiter: split_delimiter_12
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step713-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_13
      split_class: split_class_13
      split_delimiter: split_delimiter_13
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step714-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_14
      split_class: split_class_14
      split_delimiter: split_delimiter_14
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step715-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_15
      split_class: split_class_15
      split_delimiter: split_delimiter_15
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step716-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_16
      split_class: split_class_16
      split_delimiter: split_delimiter_16
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step717-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_17
      split_class: split_class_17
      split_delimiter: split_delimiter_17
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step718-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_18
      split_class: split_class_18
      split_delimiter: split_delimiter_18
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step719-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_19
      split_class: split_class_19
      split_delimiter: split_delimiter_19
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step720-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_20
      split_class: split_class_20
      split_delimiter: split_delimiter_20
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step721-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_21
      split_class: split_class_21
      split_delimiter: split_delimiter_21
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step722-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_22
      split_class: split_class_22
      split_delimiter: split_delimiter_22
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step723-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_23
      split_class: split_class_23
      split_delimiter: split_delimiter_23
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step724-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_24
      split_class: split_class_24
      split_delimiter: split_delimiter_24
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step725-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_25
      split_class: split_class_25
      split_delimiter: split_delimiter_25
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step726-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_26
      split_class: split_class_26
      split_delimiter: split_delimiter_26
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step727-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_27
      split_class: split_class_27
      split_delimiter: split_delimiter_27
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step728-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_28
      split_class: split_class_28
      split_delimiter: split_delimiter_28
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step729-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_29
      split_class: split_class_29
      split_delimiter: split_delimiter_29
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step730-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_30
      split_class: split_class_30
      split_delimiter: split_delimiter_30
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step731-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_31
      split_class: split_class_31
      split_delimiter: split_delimiter_31
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step732-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_32
      split_class: split_class_32
      split_delimiter: split_delimiter_32
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step733-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_33
      split_class: split_class_33
      split_delimiter: split_delimiter_33
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step734-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_34
      split_class: split_class_34
      split_delimiter: split_delimiter_34
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step735-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_35
      split_class: split_class_35
      split_delimiter: split_delimiter_35
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step736-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_36
      split_class: split_class_36
      split_delimiter: split_delimiter_36
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step737-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_37
      split_class: split_class_37
      split_delimiter: split_delimiter_37
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step738-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_38
      split_class: split_class_38
      split_delimiter: split_delimiter_38
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step739-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_39
      split_class: split_class_39
      split_delimiter: split_delimiter_39
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step740-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_40
      split_class: split_class_40
      split_delimiter: split_delimiter_40
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step741-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_41
      split_class: split_class_41
      split_delimiter: split_delimiter_41
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step742-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_42
      split_class: split_class_42
      split_delimiter: split_delimiter_42
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step743-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_43
      split_class: split_class_43
      split_delimiter: split_delimiter_43
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step744-split:
    run: ../../cwl/cwl-steps/run-split-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      split_property: split_property_44
      split_class: split_class_44
      split_delimiter: split_delimiter_44
      previous_step_results: step5-rdf-upload/rdf_upload_logs
    out: [execute_split_logs]

  step8-execute-transform-queries:
    run: ../../cwl/cwl-steps/execute-sparql-mapping-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_queries_path: sparql_transform_queries_path
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      previous_step_results_0: step700-split/execute_split_logs
      previous_step_results_1: step701-split/execute_split_logs
      previous_step_results_2: step702-split/execute_split_logs
      previous_step_results_3: step703-split/execute_split_logs
      previous_step_results_4: step704-split/execute_split_logs
      previous_step_results_5: step705-split/execute_split_logs
      previous_step_results_6: step706-split/execute_split_logs
      previous_step_results_7: step707-split/execute_split_logs
      previous_step_results_8: step708-split/execute_split_logs
      previous_step_results_9: step709-split/execute_split_logs
      previous_step_results_10: step710-split/execute_split_logs
      previous_step_results_11: step711-split/execute_split_logs
      previous_step_results_12: step712-split/execute_split_logs
      previous_step_results_13: step713-split/execute_split_logs
      previous_step_results_14: step714-split/execute_split_logs
      previous_step_results_15: step715-split/execute_split_logs
      previous_step_results_16: step716-split/execute_split_logs
      previous_step_results_17: step717-split/execute_split_logs
      previous_step_results_18: step718-split/execute_split_logs
      previous_step_results_19: step719-split/execute_split_logs
      previous_step_results_20: step720-split/execute_split_logs
      previous_step_results_21: step721-split/execute_split_logs
      previous_step_results_22: step722-split/execute_split_logs
      previous_step_results_23: step723-split/execute_split_logs
      previous_step_results_24: step724-split/execute_split_logs
      previous_step_results_25: step725-split/execute_split_logs
      previous_step_results_26: step726-split/execute_split_logs
      previous_step_results_27: step727-split/execute_split_logs
      previous_step_results_28: step728-split/execute_split_logs
      previous_step_results_29: step729-split/execute_split_logs
      previous_step_results_30: step730-split/execute_split_logs
      previous_step_results_31: step731-split/execute_split_logs
      previous_step_results_32: step732-split/execute_split_logs
      previous_step_results_33: step733-split/execute_split_logs
      previous_step_results_34: step734-split/execute_split_logs
      previous_step_results_35: step735-split/execute_split_logs
      previous_step_results_36: step736-split/execute_split_logs
      previous_step_results_37: step737-split/execute_split_logs
      previous_step_results_38: step738-split/execute_split_logs
      previous_step_results_39: step739-split/execute_split_logs
      previous_step_results_40: step740-split/execute_split_logs
      previous_step_results_41: step741-split/execute_split_logs
      previous_step_results_42: step742-split/execute_split_logs
      previous_step_results_43: step743-split/execute_split_logs
      previous_step_results_44: step744-split/execute_split_logs
    out: [execute_sparql_query_logs]

  step9-compute-hcls-stats:
    run: ../../cwl/cwl-steps/execute-sparql-mapping-graphdb.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_queries_path: sparql_compute_hcls_path
      sparql_triplestore_url: sparql_triplestore_url
      sparql_triplestore_repository: sparql_triplestore_repository
      sparql_input_graph_uri : sparql_input_graph_uri
      previous_step_results: step8-execute-transform-queries/execute_sparql_query_logs
    out: [execute_sparql_query_logs]
