# CWL workflows for RDF Bio2RDF conversion

The [Common Workflow Language](https://www.commonwl.org/) is used to describe workflows to transform heterogeneous structured data (CSV, TSV, RDB, XML, JSON) to the [Bio2RDF](http://bio2rdf.org/) RDF vocabularies. The user defines [SPARQL queries](https://github.com/MaastrichtU-IDS/bio2rdf/blob/master/mapping/pharmgkb/drugs.rq) to transform the generic RDF generated depending on the input data structure (AutoR2RML, xml2rdf) to the target Bio2RDF vocabulary.

* Install [Docker](https://docs.docker.com/install/) to run the modules.
* Install [cwltool](https://github.com/common-workflow-language/cwltool#install) to get cwl-runner to run workflows of Docker modules.
* Those workflows use Data2Services modules, see the [data2services-pipeline](https://github.com/MaastrichtU-IDS/data2services-pipeline) project.

---
## Clone the bio2rdf project
```shell
git clone https://github.com/MaastrichtU-IDS/bio2rdf
```
## Go to the cloned project 
```shell
cd bio2rdf
```

## Define absolute path and dataset folder as environment variables

In terminal type:

```shell
export ABS_PATH=/path/to/your/bio2rdf/folder

export DATASET=dataset_name
```
The folders of the dataset in input, output, mapping, support folders should be the same as the dataset name variable.


## Start services

[Apache Drill](https://github.com/amalic/apache-drill) and [GraphDB](https://github.com/MaastrichtU-IDS/graphdb/) services must be running before executing CWL workflows.


```shell
# Start Apache Drill sharing volume with this repository.
# Here shared locally at /data/bio2rdf
docker run -dit --rm -v ${ABS_PATH}:/data:ro -p 8047:8047 -p 31010:31010 --name drill umids/apache-drill
```

## Run your choice of triple store

#### For GraphDB:
* GraphDB needs to be built locally, for this
* Download GraphDB as a stand-alone server free version (zip): https://ontotext.com/products/graphdb/.
* Put the downloaded `.zip` file in the GraphDB repository (cloned from [GitHub](https://github.com/MaastrichtU-IDS/graphdb/)).
* Run `docker build -t graphdb --build-arg version=CHANGE_ME .` in the GraphDB repository.

```shell
# GraphDB needs to be downloaded manually and built. 
# Here shared locally at /data/graphdb and /data/graphdb-import
docker build -t graphdb --build-arg version=8.11.0 .
docker run -d --rm --name graphdb -p 7200:7200 -v ${ABS_PATH}/graphdb:/opt/graphdb/home -v ${ABS_PATH}/graphdb-import:/root/graphdb-import graphdb
```

#### For Virtuoso:


```shell
docker run --rm --name virtuoso \
    -p 8890:8890 -p 1111:1111 \
    -e DBA_PASSWORD=dba \
    -e SPARQL_UPDATE=true \
    -e DEFAULT_GRAPH=http://bio2rdf.com/bio2rdf_vocabulary: \
    -v ${ABS_PATH}/virtuoso:/data \
    -v /tmp:/tmp \
    -d tenforce/virtuoso:1.3.2-virtuoso7.2.1
```

---

## Prepare workflow
### For GraphDB:

### Create a GraphDB repository

After running the docker of GraphDB, go to: http://localhost:7200/

Create new repository in GraphDB that will store your data.


### Modify the workflow config file

Navigate to the folder of the dataset you want to convert following this path: support/_dataset_name/graphdb-workflow/config-workflow.yml

edit the file config-workflow.yml to set the following parameter depending on your environment:

sparql_triplestore_url: url_of_running_graphdb

sparql_triplestore_repository: the_repository_name_you_created_in_previous_step

working_directory: the_path_of_bio2rdf_folder


### For Virtuoso:

Edit config in the folder of the dataset you want to convert following this path: support/_dataset_name/virtuoso-workflow/config-workflow.yml

* change the working directory to the bio2rdf cloned project

working_directory: the_path_of_bio2rdf_folder

* change these parameters according to your environment if you are using different virtuoso endpoint:

sparql_triplestore_url: http://virtuoso:8890/sparql

triple_store_password: dba
triple_store_username: dba


## Run with [CWL](https://www.commonwl.org/)

* Go to the `bio2rdf` root folder (the root of the cloned repository)
  * e.g. `/data/bio2rdf` to run the CWL workflows.

* You will need to put the SPARQL mapping queries in `/mapping/$dataset_name` and provide 3 parameters:
  * `--outdir`: the [output directory](https://github.com/MaastrichtU-IDS/bio2rdf/tree/master/output/pharmgkb) for files outputted by the workflow (except for the downloaded source files that goes automatically to `/input`). 
    * e.g. `${ABS_PATH}/output/${DATASET}`.
  * The `.cwl` [workflow file](https://github.com/MaastrichtU-IDS/bio2rdf/blob/master/support/pharmgkb/virtuoso-workflow/workflow.cwl)
    * e.g. `${ABS_PATH}/support/${DATASET}/virtuoso-workflow/workflow.cwl`
  * The `.yml` [configuration file](https://github.com/MaastrichtU-IDS/bio2rdf/blob/master/support/pharmgkb/virtuoso-workflow/config-workflow.yml) with all parameters required to run the workflow
    * e.g. `${ABS_PATH}/support/${DATASET}/virtuoso-workflow/config-workflow.yml`

* 3 types of workflows can be run depending on the input data:
  * Convert XML to RDF
  * Convert CSV to RDF
  * Convert CSV to RDF and split a property

### Convert CSV/TSV with [AutoR2RML](https://github.com/amalic/autor2rml)


```shell
cwl-runner --outdir ${ABS_PATH}/output/${DATASET} ${ABS_PATH}/support/${DATASET}/virtuoso-workflow/workflow.cwl ${ABS_PATH}/support/${DATASET}/virtuoso-workflow/config-workflow.yml
```

See [config file](https://github.com/MaastrichtU-IDS/bio2rdf/blob/master/support/sider/virtuoso-workflow/config-workflow.yml):

```yaml
working_directory: /media/apc/DATA1/Maastricht/bio2rdf-github

dataset: sider

# R2RML params
input_data_jdbc: "jdbc:drill:drillbit=drill:31010"
sparql_tmp_graph_uri: "https://w3id.org/data2services/graph/autor2rml/sider"
sparql_base_uri: "https://w3id.org/data2services/"
#autor2rml_column_header: "test1,test2,test3,test5"

# RdfUpload params
sparql_triplestore_url: http://graphdb:7200
sparql_triplestore_repository: sider


sparql_transform_queries_path: /data/mapping/sider/transform
sparql_insert_metadata_path: /data/mapping/sider/metadata
```

### Convert CSV/TSV with [AutoR2RML](https://github.com/amalic/autor2rml) and split a property (Will be available shortly)


### Run in the background

Will write all terminal output to `nohup.out`.

```shell
cwl-runner --outdir  ${ABS_PATH}/output/${DATASET}  ${ABS_PATH}/support/${DATASET}/virtuoso-workflow/workflow.cwl  ${ABS_PATH}/support/${DATASET}/virtuoso-workflow/config-workflow.yml
```
