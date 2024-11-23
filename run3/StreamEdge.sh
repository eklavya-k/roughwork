#!/bin/bash

export PATH=$PATH:/run/current-system/sw/bin/

#setting edge configs (user, memory, cores etc...)

edgeConfig=$(curl https://flux.internal.reports.mn/GetEdgeConfigs\?id="$1")

for key in $(echo "$edgeConfig" | jq -r 'keys_unsorted[]'); do
    value=$(echo "$edgeConfig" | jq -r ".$key")
    export $key="$value"
done

LOG4J_PATH=hdfs://nameservice1/prod_code/Data/master/config/log4j.properties

export extra_jars=hdfs://nameservice1/user/eklavya.k/ad_click_flow_in/hiveudf-1.0-SNAPSHOT.jar,hdfs://nameservice1/user/data_admin/hadoop-styx/spark-sql-patch-3.0.jar,hdfs://${cluster}/user/data_admin/Data_deps/*.jar

printenv

HADOOP_USER_NAME=hdfs spark-submit \
	--name ${app_name} \
	--master yarn \
	--deploy-mode cluster  \
	--queue ${queue} \
	--driver-memory ${driver_memory} \
	--executor-memory ${executor_memory} \
	--executor-cores ${executor_cores} \
        --conf spark.hadoop.dfs.nameservices=${cluster},nameservice1 \
        --conf spark.hadoop.dfs.ha.namenodes.nameservice1=namenode111,namenode65 \
        --conf spark.hadoop.dfs.client.failover.proxy.provider.nameservice1=org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider \
        --conf spark.hadoop.dfs.ha.automatic-failover.enabled.nameservice1=true \
        --conf spark.hadoop.dfs.namenode.rpc-address.nameservice1.namenode111=c8-auto-hadoop-service-1.srv.media.net:8020 \
        --conf spark.hadoop.dfs.namenode.rpc-address.nameservice1.namenode65=c8-auto-hadoop-service-2.srv.media.net:8020 \
        --conf spark.hadoop.dfs.namenode.servicerpc-address.nameservice1.namenode111=c8-auto-hadoop-service-1.srv.media.net:8022 \
        --conf spark.hadoop.dfs.namenode.servicerpc-address.nameservice1.namenode65=c8-auto-hadoop-service-2.srv.media.net:8022 \
        --conf spark.hadoop.dfs.namenode.http-address.nameservice1.namenode111=c8-auto-hadoop-service-1.srv.media.net:9870 \
        --conf spark.hadoop.dfs.namenode.http-address.nameservice1.namenode65=c8-auto-hadoop-service-2.srv.media.net:9870 \
        --conf spark.hadoop.dfs.namenode.https-address.nameservice1.namenode111=c8-auto-hadoop-service-1.srv.media.net:9871 \
        --conf spark.hadoop.dfs.namenode.https-address.nameservice1.namenode65=c8-auto-hadoop-service-2.srv.media.net:9871 \
	--conf "spark.driver.extraJavaOptions=-Dlog4j.configuration=file:log4j.properties -Dlog4j.debug=true -Dfile.encoding=UTF-8" \
        --conf "spark.executor.extraJavaOptions=-Dlog4j.configuration=file:log4j.properties -Dlog4j.debug=true -Dfile.encoding=UTF-8" \
	--conf spark.sql.log.entry.retain.time.ms=${log_entry_retain_time} \
	--conf spark.dynamicAllocation.enabled=true \
	--conf spark.shuffle.service.enabled=true \
        --conf spark.yarn.submit.waitAppCompletion=false \
        --conf spark.yarn.dist.files=hdfs://nameservice1/user/suryansh.k/hive-site.xml \
        --conf spark.driver.extraClassPath=snakeyaml-1.10.jar:spark-sql-patch-3.0.jar:spark-sql-kafka-0-10_2.12-3.5.0.jar:kafka-clients-3.4.1.jar:spark-token-provider-kafka-0-10_2.12-3.5.0.jar:spark-streaming-kafka-0-10_2.12-3.5.0.jar:$DATA_DRIVER_CLASSPATH \
        --conf spark.executor.extraClassPath=snakeyaml-1.10.jar:$DATA_EXECUTOR_CLASSPATH \
        --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
	--jars ${rule_service_jar},${extra_jars} \
        ${extra_conf} \
	--files $METRICS_PATH,$LOG4J_PATH \
	--class net.media.spark.context.SparkSessionContext ${spark_processing_jar} -e ${edge_id} -db jdbc:mysql://c8-auto-flux-db.srv.media.net:6600/flux -u flux_web -p fpibcmdu49