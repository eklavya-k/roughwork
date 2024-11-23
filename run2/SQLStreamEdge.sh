#!/bin/bash
export spark_ui_retained_stages=1000

rm -rf setVarsFlow.py
hadoop dfs -copyToLocal /prod_code/Rule-Manager/master/scripts/setVarsFlow.py .
eval "$(curl https://flux.internal.reports.mn/GetEdgeConfigs\?id=$1 | python setVarsFlow.py)"

HADOOP_USER_NAME=${user_name} spark-submit \
  --name ${app_name} \
  --master yarn \
  --deploy-mode cluster  \
  --queue ${queue}  \
  --executor-memory ${executor_memory} --executor-cores ${executor_cores} \
  --conf spark.metrics.namespace=${app_name} \
  --conf spark.metrics.conf=metrics_new.properties \
  --conf spark.streaming.kafka.consumer.cache.maxCapacity=120 \
  --conf spark.streaming.kafka.maxRatePerPartition=400 \
  --conf spark.streaming.kafka.maxRetries=3 \
  --conf spark.dynamicAllocation.enabled=false \
  --conf spark.streaming.dynamicAllocation.enabled=true \
  --conf spark.streaming.dynamicAllocation.scalingUpRatio=1.0 \
  --conf spark.streaming.dynamicAllocation.scalingDownRatio=0.9 \
  --conf spark.streaming.dynamicAllocation.maxExecutors=2 \
  --conf spark.streaming.stopGracefullyOnShutdown=true \
  --conf spark.ui.retainedStages=${spark_ui_retained_stages} \
  --jars ${rule_service_jar},${extra_jars} \
  --conf spark.driver.extraClassPath=$DATA_DRIVER_CLASSPATH \
  --conf spark.executor.extraClassPath=$DATA_EXECUTOR_CLASSPATH  \
  --conf spark.yarn.submit.waitAppCompletion=false \
  ${extra_conf} \
  --files $METRICS_PATH --class net.media.spark.context.StreamContext ${spark_processing_jar}  \
  -e ${edge_id} -db jdbc:mysql://c8-auto-flux-db.srv.media.net:6600/flux -u flux_web -p fpibcmdu49