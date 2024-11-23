#!/bin/bash


#defaults for backward compatibility .. for edges which haven't been deployed again after adding argumentss
comma_separated_partitions=ts;export comma_separated_partitions

rm -rf setVarsFlow.py
hadoop dfs -copyToLocal /prod_code/Rule-Manager/master/scripts/setVarsFlow.py .
eval "$(curl https://flux.internal.reports.mn/GetEdgeConfigs\?id=$2 | python setVarsFlow.py)"

HADOOP_USER_NAME=${user_name} spark-submit \
  --name ${app_name}  \
  --driver-memory ${driver_memory} \
  --executor-memory ${executor_memory}  \
  --executor-cores ${executor_cores} \
  --master yarn-cluster --deploy-mode cluster  \
  --queue ${queue} \
  --jars ${rule_service_jar},${extra_jars} \
  --conf spark.driver.extraClassPath=$DATA_DRIVER_CLASSPATH \
  --conf spark.executor.extraClassPath=$DATA_EXECUTOR_CLASSPATH \
  ${extra_conf} \
  --class net.media.spark.context.${context_class} \
  ${spark_processing_jar} -e ${edge_id} -data_partition ${comma_separated_partitions}=$1 -db jdbc:mysql://c8-auto-flux-db.srv.media.net:6600/flux -u flux_web -p fpibcmdu49