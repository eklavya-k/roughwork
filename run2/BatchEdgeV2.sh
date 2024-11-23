#!/bin/bash


#defaults for backward compatibility .. for edges which haven't been deployed again after adding argumentss
comma_separated_partitions=ts;export comma_separated_partitions

rm -rf setVarsFlow.py
hadoop dfs -copyToLocal /user/data_admin/ankur.y/setvarsflow.py
eval "$(curl https://flux.internal.reports.mn/GetEdgeConfigs\?id=$2 | python setvarsflow.py)"


HADOOP_USER_NAME=${user_name} spark-submit \
  --name ${app_name}  \
  --driver-memory ${driver_memory} \
  --executor-memory ${executor_memory}  \
  --executor-cores ${executor_cores} \
  --master yarn --deploy-mode cluster  \
  --queue ${queue} \
  --jars hdfs://nameservice1/user/data_admin/ankur.y/rule-service-2.4-rc75.jar,${extra_jars} \
  --conf spark.driver.extraClassPath=$DATA_DRIVER_CLASSPATH \
  --conf spark.executor.extraClassPath=$DATA_EXECUTOR_CLASSPATH \
  ${extra_conf} \
  --class net.media.spark.context.SparkSessionContext \
  ${spark_processing_jar} -e ${edge_id} -n $1 -db jdbc:mysql://c8-auto-flux-db.srv.media.net:6600/flux -u flux_web -p fpibcmdu49
