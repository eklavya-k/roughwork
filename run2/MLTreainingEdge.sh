#!/bin/bash -ex

if [[ -z $TARGET_SPARK_HOME ]]; then
  TARGET_SPARK_HOME=$(grep --only-matching "SPARK_HOME=.*" ./spark-conf-temp/spark-env.sh | sed "s/SPARK_HOME=//;s/\"//g")
  echo "Found target spark home from spark-env.sh = $TARGET_SPARK_HOME"
else
  echo "Given target spark home = $TARGET_SPARK_HOME"
fi


export HADOOP_OPTS="-Ddfs.nameservices=mlens1 -Ddfs.ha.namenodes.mlens1=namenode111,namenode65 -Ddfs.client.failover.proxy.provider.mlens1=org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider -Ddfs.ha.automatic-failover.enabled.mlens1=true -Ddfs.namenode.rpc-address.mlens1.namenode111=c8-auto-hadoop-service-1.srv.media.net:8020 -Ddfs.namenode.rpc-address.mlens1.namenode65=c8-auto-hadoop-service-2.srv.media.net:8020 -Ddfs.namenode.servicerpc-address.mlens1.namenode111=c8-auto-hadoop-service-1.srv.media.net:8022 -Ddfs.namenode.servicerpc-address.mlens1.namenode65=c8-auto-hadoop-service-2.srv.media.net:8022 -Ddfs.namenode.http-address.mlens1.namenode111=c8-auto-hadoop-service-1.srv.media.net:9870 -Ddfs.namenode.http-address.mlens1.namenode65=c8-auto-hadoop-service-2.srv.media.net:9870 -Ddfs.namenode.https-address.mlens1.namenode111=c8-auto-hadoop-service-1.srv.media.net:9871 -Ddfs.namenode.https-address.mlens1.namenode65=c8-auto-hadoop-service-2.srv.media.net:9871"

edge_id=${1}
operation_type=${2}
run_start_epoch_secs=${3}
spark_master=${4}

echo "edge_id : ${edge_id} | operation_type : ${operation_type} | run_start_epoch_secs : ${run_start_epoch_secs}"

base_dir="hdfs://mlens1/prod_code/Flow-ML-Edge/master"

py_module_zip_hdfs_path=${base_dir}/ml_training_edge/jars/ml_training_edge-1.0.0-src.zip
main_py_file_hdfs_path=${base_dir}/ml_training_edge/driver/main.py
dask_config_dask_hdfs=${base_dir}/ml_training_edge/dask-config.yaml

main_py_file_local_path=./main.py
py_module_local_path=./ml_edge.zip
dask_config_dask_local=./dask-config.yaml

hadoop dfs ${HADOOP_OPTS} -copyToLocal -f ${main_py_file_hdfs_path} ${main_py_file_local_path}
hadoop dfs ${HADOOP_OPTS} -copyToLocal -f ${py_module_zip_hdfs_path} ${py_module_local_path}
hadoop dfs ${HADOOP_OPTS} -copyToLocal -f ${dask_config_dask_hdfs} ${dask_config_dask_local}

export PYTHONPATH=${py_module_local_path}:$PYTHONPATH
touch "./requirements.txt"

eval "$(/usr/bin/python3.8 ${main_py_file_local_path} 'export_env_vars' ${operation_type} ${edge_id})"

ml_edge_env_hdfs_path=${PYTHON_ENV_PATH}
export PYSPARK_PYTHON=./environment/pyWrapper
export PYSPARK_DRIVER_PYTHON=./environment/pyWrapper

if [[ ! -z $SPARK_JARS_ARCHIVE ]]; then
  SPARK_JARS_ARCHIVE_CONF="--conf spark.yarn.archive=hdfs://mlens1${SPARK_JARS_ARCHIVE}"
else
  SPARK_JARS_ARCHIVE_CONF=""
fi

unset HADOOP_CONF_DIR

# Define function to decode base64 encoded strings
function decode_base64() {
    echo "$1" | base64 --decode
}

# Define function that calls API and creates hadoopConf directory with child files
function export_hadoop_conf() {
    rm -rf hadoopConf
    local cluster_name="$1"
    api_response=$(curl -s http://cluster-service.srv.media.net/cluster?name=${cluster_name})

    # Parse response to find hadoopConf key and its child keys ending with .xml
    child_keys=$(echo "$api_response" | jq -r '.hadoopConf | with_entries(select(.key | endswith(".xml"))) | keys[]')

    # Create hadoopConf directory
    mkdir hadoopConf

    # Loop through child keys and create files with child key name and value as content
    for key in $child_keys; do
        encoded_value=$(echo "$api_response" | jq -r ".hadoopConf[\"$key\"]")
        decoded_value=$(decode_base64 "$encoded_value")
        echo "$decoded_value" > hadoopConf/"$key"
    done
    export HADOOP_CONF_DIR=hadoopConf

}

# Make the curl request and store the response in a variable
edgeConfig=$(curl -s https://flux.internal.reports.mn/GetEdgeConfigs?id=${1})
cluster=$(echo "$edgeConfig" | jq -r '.cluster')

#setting target cluster confs ( we need to explicitly set this here because adc-data-hadoop is a new cluster and its config/resource changes frequently.)
export_hadoop_conf "${cluster}"
# spark conf is already set

HADOOP_USER_NAME=${USER_NAME} spark-submit \
  --verbose \
  --py-files ${py_module_local_path}${EXTRA_PY_FILES} \
  --name ${APP_NAME} \
  --deploy-mode cluster \
  --master ${spark_master} \
  --queue ${YARN_QUEUE} ${NUM_EXECUTORS_STRING} \
  --conf spark.driver.cores=${DRIVER_CORES} \
  --conf spark.driver.memory=${DRIVER_MEMORY} \
  --conf spark.executor.cores=${EXECUTOR_CORES} \
  --conf spark.executor.memory=${EXECUTOR_MEMORY} \
  --conf spark.task.cpus=${TASK_CORES} \
  --conf spark.scheduler.minRegisteredResourcesRatio=1.0 \
  --conf spark.yarn.appMasterEnv.SPARK_HOME="${TARGET_SPARK_HOME}" \
  --conf spark.executorEnv.SPARK_HOME="${TARGET_SPARK_HOME}" \
  --conf spark.yarn.appMasterEnv.PYSPARK_PYTHON=${PYSPARK_PYTHON} \
  --conf spark.yarn.appMasterEnv.PYSPARK_DRIVER_PYTHON=${PYSPARK_DRIVER_PYTHON} \
  --conf spark.executorEnv.PYSPARK_PYTHON=${PYSPARK_PYTHON} \
  --conf spark.executorEnv.PYSPARK_DRIVER_PYTHON=${PYSPARK_DRIVER_PYTHON} \
  --conf spark.yarn.appMasterEnv.PROCESSOR_TYPE="cpu" \
  --conf spark.executorEnv.PROCESSOR_TYPE="cpu" \
  --conf spark.executor.heartbeatInterval=5000s \
  --conf spark.network.timeout=5100s \
  --conf spark.python.use.daemon=false \
  ${SPARK_JARS_ARCHIVE_CONF} \
  ${ENV_SPECIFIC_CONF} ${EXTRA_JARS} ${SPARK_SUBMIT_HADOOP_OPTS} \
  --files requirements.txt,${dask_config_dask_local} \
  --archives ${ml_edge_env_hdfs_path} \
  ${main_py_file_local_path} 'run_ml_edge' ${operation_type} ${edge_id} ${run_start_epoch_secs}

rm ${main_py_file_local_path}
rm ${py_module_local_path}
rm "./requirements.txt"
rm ${dask_config_dask_local}