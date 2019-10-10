# CWL workflows for RDF BioLink conversion

The [Common Workflow Language](https://www.commonwl.org/) is used to describe workflows to transform heterogeneous structured data (CSV, TSV, RDB, XML, JSON) to the [Bio2RDF](http://bio2rdf.org/) RDF vocabularies. The user defines [SPARQL queries](https://github.com/MaastrichtU-IDS/bio2rdf/blob/master/mapping/pharmgkb/drugs.rq) to transform the generic RDF generated depending on the input data structure (AutoR2RML, xml2rdf) to the target Bio2RDF vocabulary.

* Install [Docker](https://docs.docker.com/install/) to run the modules.
* Install [cwltool](https://github.com/common-workflow-language/cwltool#install) to get cwl-runner to run workflows of Docker modules.
* Those workflows use Data2Services modules, see the [data2services-pipeline](https://github.com/MaastrichtU-IDS/data2services-pipeline) project.

---

## Define absolute path and dataset folder as environment variables

In terminal type:

```shell
export ABS_PATH=/path/to/your/bio2rdf/folder

export DATASET=dataset_name
```
The folders of the dataset in input, output, mapping, support folders should be the same as the dataset name variable.

## Start services

[Apache Drill](https://github.com/amalic/apache-drill) and [GraphDB](https://github.com/MaastrichtU-IDS/graphdb/) services must be running before executing CWL workflows.

GraphDB needs to be built locally, for this:

* Download GraphDB as a stand-alone server free version (zip): https://ontotext.com/products/graphdb/.
* Put the downloaded `.zip` file in the GraphDB repository (cloned from [GitHub](https://github.com/MaastrichtU-IDS/graphdb/)).
* Run `docker build -t graphdb --build-arg version=CHANGE_ME .` in the GraphDB repository.

```shell
# Start Apache Drill sharing volume with this repository.
# Here shared locally at /data/bio2rdf
docker run -dit --rm -v /data/bio2rdf:/data:ro -p 8047:8047 -p 31010:31010 --name drill vemonet/apache-drill

# GraphDB needs to be downloaded manually and built. 
# Here shared locally at /data/graphdb and /data/graphdb-import
docker build -t graphdb --build-arg version=8.11.0 .
docker run -d --rm --name graphdb -p 7200:7200 -v /data/graphdb:/opt/graphdb/home -v /data/graphdb-import:/root/graphdb-import graphdb
```

---

## Run with [CWL](https://www.commonwl.org/)

* Go to the `bio2rdf` root folder (the root of the cloned repository)
  * e.g. `/data/bio2rdf` to run the CWL workflows.

* You will need to put the SPARQL mapping queries in `/mapping/$dataset_name` and provide 3 parameters:
  * `--outdir`: the [output directory](https://github.com/MaastrichtU-IDS/bio2rdf/tree/master/output/pharmgkb) for files outputted by the workflow (except for the downloaded source files that goes automatically to `/input`). 
    * e.g. `output/$dataset_name`.
  * The `.cwl` [workflow file](https://github.com/MaastrichtU-IDS/bio2rdf/blob/master/support/pharmgkb/workflow.cwl)
    * e.g. `support/pharmgkb/workflow.cwl`
  * The `.yml` [configuration file](https://github.com/MaastrichtU-IDS/bio2rdf/blob/master/support/pharmgkb/workflow-job.yml) with all parameters required to run the workflow
    * e.g. `support/pharmgkb/workflow-job.yml`

* 3 types of workflows can be run depending on the input data:
  * [Convert XML to RDF](https://github.com/MaastrichtU-IDS/bio2rdfk#convert-xml-with-xml2rdf) (Will be available shortly)
  * [Convert CSV to RDF](https://github.com/MaastrichtU-IDS/bio2rdf#convert-csvtsv-with-autor2rml)
  * [Convert CSV to RDF and split a property](Will be available shortly)

### Convert XML with [xml2rdf](Will be available shortly)


### Convert CSV/TSV with [AutoR2RML](https://github.com/amalic/autor2rml)


```shell
cwl-runner --outdir output/pharmgkb support/pharmgkb/workflow.cwl support/pharmgkb/workflow-job.yml
```

See [config file](https://github.com/MaastrichtU-IDS/bio2rdf/blob/master/support/pharmgkb/workflow-job.yml):

```yaml
abs_path: /home/apc/Maastricht/bio2rdf-github 
dataset: pharmgkb

step1_jdbc: "jdbc:drill:drillbit=drill:31010"
step1_trig_file: mapping.trig
step1_trig: valueFrom
step1_data: valueFrom
step1_baseuri: "https://w3id.org/data2services/"
step1_graph: "https://w3id.org/data2services/graph/autor2rml"

step2_jdbc: jdbc:drill:drillbit=drill:31010
step2_rq_file: rdf_output.nq
step2_text: valueFrom

step3_config: valueFrom

step4_rq: valueFrom
step4_method: HTTP
step4_url: http://graphdb:7200
step4_repo: test

step6_sparql: /data/mapping/pharmgkb
step6_endpoint: http://graphdb:7200/repositories/test/statements
```

### Convert CSV/TSV with [AutoR2RML](https://github.com/amalic/autor2rml) and split a property (Will be available shortly)


### Run in the background

Will write all terminal output to `nohup.out`.

```shell
nohup cwl-runner --outdir output/pharmgkb support/pharmgkb/workflow.cwl support/pharmgkb/workflow-job.yml
```


---

# Argo workflows

See [Argo README](https://github.com/MaastrichtU-IDS/data2services-transform-biolink/tree/master/support/argo) to run workflows with Argo.
