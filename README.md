# docker-pyspark-notebook
Dockerized Apache Spark Notebook with pluggable python or jvm dependencies.

Docker Hub image available [here](https://hub.docker.com/r/bbarbieru/pyspark-notebook/)

#### Requirements
 * docker
 * docker-compose
 
#### Building
* `docker-compose build`

#### Running
* `docker-compose up -d`
* Notebook server accessible at `localhost:8888`
* When a new notebook is created or opened withing IPython a SparkContext is initiallized (`sc`) using the default values from `conf/spark-defaults.conf` also a Spark SqlContext is created (`sqlContext`)
