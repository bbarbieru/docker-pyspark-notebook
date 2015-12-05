FROM debian:latest

# IPython dependencies
RUN    apt-get update \
    && apt-get install -y \
	       python \
               python-dev \
               python-pip \
               python-zmq \
               wget \
	       tar \
               unzip

# IPython dependencies
RUN pip install ipython[notebook]==3.2 \
                jinja2 \
                jsonschema \
                py4j \
                terminado \
                tornado

WORKDIR /jdk/
RUN wget \
        --no-check-certificate \
        --no-cookies \
        --header "Cookie: oraclelicense=accept-securebackup-cookie" \
        http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.tar.gz \
    && tar -xvf jdk-8u65-linux-x64.tar.gz \
    && chown -R root:root /jdk/jdk1.8.0_65 \
    && rm jdk-8u65-linux-x64.tar.gz
ENV JAVA_HOME /jdk/jdk1.8.0_65

# Spark 1.5.2 setup
WORKDIR /spark
RUN     wget http://apache.mirror.anlx.net/spark/spark-1.5.2/spark-1.5.2-bin-hadoop2.6.tgz \
     && tar -xvf spark-1.5.2-bin-hadoop2.6.tgz \
     && mv spark-1.5.2-bin-hadoop2.6 1.5.2 \
     && rm spark-1.5.2-bin-hadoop2.6.tgz

ENV SPARK_HOME /spark/1.5.2
ENV PATH $PATH:$SPARK_HOME/bin
ENV PYTHONPATH $SPARK_HOME/python/

RUN echo "***** ENV ****" && env

COPY conf/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf
COPY conf/spark-env.sh $SPARK_HOME/conf/spark-env.sh
COPY conf/hive-site.xml $SPARK_HOME/conf/hive-site.xml
COPY jvm_libs /jvm_libs

# Ipython
COPY style/fonts_and_container_custom.css /notebook/style/fonts_and_container_custom.css
COPY pyspark_setup.py /notebook/startup/pyspark_setup.py

RUN    ipython profile create pyspark \
    && wget \
	   --no-check-certificate \ 
	   -O `ipython locate profile pyspark`/static/custom/custom.css \
           https://raw.githubusercontent.com/nsonnad/base16-ipython-notebook/master/ipython-3/output/base16-monokai-dark.css \
    && cat /notebook/style/fonts_and_container_custom.css >> `ipython locate profile pyspark`/static/custom/custom.css \
    && cp /notebook/startup/pyspark_setup.py `ipython locate profile pyspark`/startup/pyspark_setup.py \
    && rm -r /notebook/st*

# Install Python Libs
WORKDIR /usr/local/lib/python2.7/dist-packages
COPY python_libs/ /usr/local/lib/python2.7/dist-packages/

VOLUME /notebook
WORKDIR /notebook

EXPOSE 8888
CMD pyspark
