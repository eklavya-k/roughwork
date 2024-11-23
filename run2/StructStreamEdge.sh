#!/bin/bash

LOG4J_PATH=hdfs://nameservice1/prod_code/Data/master/config/log4j.properties

rm -rf setVarsFlow.py
hadoop dfs -copyToLocal /prod_code/Rule-Manager/master/scripts/setVarsFlow.py .
eval "$(curl https://flux.internal.reports.mn/GetEdgeConfigs\?id=$1 | python setVarsFlow.py)"

printenv


HADOOP_USER_NAME=${user_name} spark-submit \
	--name ${app_name} \
	--master yarn \
	--deploy-mode cluster  \
	--queue ${queue} \
	--driver-memory ${driver_memory} \
	--executor-memory ${executor_memory} \
	--executor-cores ${executor_cores} \
	--conf "spark.driver.extraJavaOptions=-Dlog4j.configuration=file:log4j.properties -Dlog4j.debug=true -Dfile.encoding=UTF-8 -XX:+UseG1GC" \
	--conf "spark.executor.extraJavaOptions=-Dlog4j.configuration=file:log4j.properties -Dlog4j.debug=true -Dfile.encoding=UTF-8 -XX:+UseG1GC" \
	--conf spark.sql.log.entry.retain.time.ms=${log_entry_retain_time} \
	--conf spark.dynamicAllocation.enabled=true \
	--conf spark.shuffle.service.enabled=true \
	--conf spark.shuffle.reduceLocality.enabled=false \
	--conf spark.dynamicAllocation.executorIdleTimeout=${executor_idle_timeout}s \
	--conf spark.dynamicAllocation.maxExecutors=${max_executors}  \
	--conf spark.dynamicAllocation.minExecutors=${min_executors} \
	--conf spark.executor.memoryOverhead=${yarn_executor_memory_overhead} \
	--jars ${rule_service_jar},${extra_jars} \
	--conf spark.driver.extraClassPath=$DATA_DRIVER_CLASSPATH:hbase-site.xml \
	--conf spark.executor.extraClassPath=$DATA_EXECUTOR_CLASSPATH:hbase-site.xml ${extra_conf} \
  --conf spark.yarn.submit.waitAppCompletion=false \
	--files $METRICS_PATH,$HBASE_PATH,$LOG4J_PATH \
	--class net.media.spark.context.StreamContext ${spark_processing_jar} -e ${edge_id} -db jdbc:mysql://c8-auto-flux-db.srv.media.net:6600/flux -u flux_web -p fpibcmdu49