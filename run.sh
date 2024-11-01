#!/bin/bash
printenv

DATA_EXECUTOR_CLASSPATH=/etc/hive/conf:spark-streaming-kafka-0-10_2.11-2.4.0.jar:kafka-clients-2.5.0.jar:metrics.properties:etl-gson-2.2.5.jar:guava-16.0.1.jar:spark-sql-patch-3.0.jar:spark-sql-kafka-0-10_2.11-2.4.0.jar:hbase-site.xml
DATA_DRIVER_CLASSPATH=spark-streaming-kafka-0-10_2.11-2.4.0.jar:kafka-clients-2.5.0.jar:metrics.properties:etl-gson-2.2.5.jar:guava-16.0.1.jar:hbase-common-2.1.0-cdh6.3.1.jar:hbase-hadoop2-compat-2.1.0-cdh6.3.1.jar:hbase-protocol-shaded-2.1.0-cdh6.3.1.jar:hbase-hadoop-compat-2.1.0-cdh6.3.1.jar:hbase-metrics-api-2.1.0-cdh6.3.1.jar:hamcrest-core-1.3.jar:hbase-shaded-protobuf-2.2.1.jar:hbase-protocol-2.1.0-cdh6.3.1.jar:hbase-shaded-netty-2.2.1.jar:hbase-metrics-2.1.0-cdh6.3.1.jar:joni-2.1.11.jar:error_prone_annotations-2.3.3.jar:junit-4.12.jar:hbase-client-2.1.0-cdh6.3.1.jar:jcodings-1.0.18.jar:hbase-shaded-miscellaneous-2.2.1.jar:spark-sql-patch-3.0.jar:spark-sql-kafka-0-10_2.11-2.4.0.jar:hbase-site.xml

HADOOP_USER_NAME=${user_name} spark-submit \
--name ${app_name}  \
--driver-memory 16G \
--executor-memory 16g  \
--executor-cores 1 \
--conf spark.driver.memoryOverhead=3g \
--conf spark.executor.memoryOverhead=3g \
--master yarn-cluster --deploy-mode cluster  \
--queue ${queue} \
--jars ${rule_service_jar},${extra_jars} \
--conf spark.executor.memoryOverhead=2g \
--conf spark.driver.extraClassPath=$DATA_DRIVER_CLASSPATH \
--conf spark.executor.extraClassPath=$DATA_EXECUTOR_CLASSPATH \
--conf spark.kryoserializer.buffer.max=512m \
${extra_conf} \
--class net.media.spark.context.${context_class} \
${spark_processing_jar} -f ${job_prop_path} -data_partition ts=0001010100