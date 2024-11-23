#!/bin/bash

#setting edge configs (user, memory, cores etc...)

eval edgeConfig=$(curl https://flux.internal.reports.mn/GetEdgeConfigs\?id="${edge_id_arg}")

for key in $(echo "$edgeConfig" | jq -r 'keys_unsorted[]'); do
    value=$(echo "$edgeConfig" | jq -r ".$key")
    export $key="$value"
done

printenv

eval HADOOP_USER_NAME=${user_name} spark-submit \
    --name ${app_name} \
    --master yarn \
    --deploy-mode cluster  \
    --queue ${queue} \
    --driver-memory ${driver_memory} \
    --executor-memory ${executor_memory} \
    --executor-cores ${executor_cores} \
    --conf "spark.driver.extraJavaOptions=-Dlog4j.configuration=file:log4j.properties -Dlog4j.debug=true -Dfile.encoding=UTF-8 -XX:+UseG1GC" \
    --conf "spark.executor.extraJavaOptions=-Dlog4j.configuration=file:log4j.properties -Dlog4j.debug=true -Dfile.encoding=UTF-8 -XX:+UseG1GC" \
    --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
    --conf spark.yarn.dist.files=hdfs://nameservice1/prod_code/Rule-Manager/master/config/hive-site.xml \
    --jars ${rule_service_jar},${extra_jars} ${spark_conf} \
    --conf spark.driver.extraClassPath=$DATA_DRIVER_CLASSPATH:hbase-site.xml \
    --conf spark.executor.extraClassPath=$DATA_EXECUTOR_CLASSPATH:hbase-site.xml ${extra_conf} \
    --files $METRICS_PATH,$HBASE_PATH,$LOG4J_PATH \
    --class net.media.spark.context.${context_class} ${spark_processing_jar} ${main_class_args}