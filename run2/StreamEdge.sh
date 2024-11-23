#!/bin/bash

LOG4J_PATH=hdfs://nameservice1/prod_code/Data/master/config/log4j.properties

rm -rf setVarsFlow.py
hadoop dfs -copyToLocal /prod_code/Rule-Manager/master/scripts/setVarsFlow.py .
eval "$(curl https://flux.internal.reports.mn/GetEdgeConfigs\?id=$1 | python setVarsFlow.py)"

HADOOP_USER_NAME=${user_name} spark-submit --name ${app_name} --master yarn --deploy-mode cluster  --queue ${queue}  \
  --driver-memory ${driver_memory} \
  --executor-memory ${executor_memory} \
  --executor-cores ${executor_cores} \
  --conf "spark.driver.extraJavaOptions=-Dlog4j.configuration=file:log4j.properties -Dlog4j.debug=true -Dfile.encoding=UTF-8" \
  --conf "spark.executor.extraJavaOptions=-Dlog4j.configuration=file:log4j.properties -Dlog4j.debug=true -Dfile.encoding=UTF-8" \
  --conf spark.metrics.namespace=${app_name} \
  --conf spark.metrics.conf=metrics_new.properties \
  --jars ${rule_service_jar},${extra_jars} \
  --conf spark.driver.extraClassPath=$DATA_DRIVER_CLASSPATH \
  --conf spark.executor.extraClassPath=$DATA_EXECUTOR_CLASSPATH  \
  ${extra_conf} \
  --files $METRICS_PATH,$LOG4J_PATH --class net.media.spark.context.SparkSessionContext ${spark_processing_jar}  \
  -e ${edge_id} -db jdbc:mysql://c8-auto-flux-db.srv.media.net:6600/flux -u flux_web -p fpibcmdu49