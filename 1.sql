call UPDATE_FLOW_SPARK_DATA_CLASSPATHS(
	@id := 7,
	@category := 'DRIVER',
	@classpath := 'spark-streaming-kafka-0-10_2.11-2.4.0.jar:kafka-clients-2.5.0.jar:metrics.properties:etl-gson-2.2.5.jar:guava-16.0.1.jar:hbase-common-2.1.0-cdh6.3.1.jar:hbase-hadoop2-compat-2.1.0-cdh6.3.1.jar:hbase-protocol-shaded-2.1.0-cdh6.3.1.jar:hbase-hadoop-compat-2.1.0-cdh6.3.1.jar:hbase-metrics-api-2.1.0-cdh6.3.1.jar:hamcrest-core-1.3.jar:hbase-shaded-protobuf-2.2.1.jar:hbase-protocol-2.1.0-cdh6.3.1.jar:hbase-shaded-netty-2.2.1.jar:hbase-metrics-2.1.0-cdh6.3.1.jar:joni-2.1.11.jar:error_prone_annotations-2.3.3.jar:junit-4.12.jar:hbase-client-2.1.0-cdh6.3.1.jar:jcodings-1.0.18.jar:hbase-shaded-miscellaneous-2.2.1.jar:spark-sql-patch-3.0.jar:spark-sql-kafka-0-10_2.11-2.4.0.jar:hbase-site.xml',
	@description := 'rule test driver classpath',
	@user_name := 'eklavya.k'
);

call UPDATE_FLOW_SPARK_DATA_CLASSPATHS(
    @id := 8,
	@category := 'EXECUTOR',
	@classpath := '/etc/hive/conf:spark-streaming-kafka-0-10_2.11-2.4.0.jar:kafka-clients-2.5.0.jar:metrics.properties:etl-gson-2.2.5.jar:guava-16.0.1.jar:spark-sql-patch-3.0.jar:spark-sql-kafka-0-10_2.11-2.4.0.jar:hbase-site.xml',
    @description := 'rule test executor classpath',
	@user_name := 'eklavya.k'
);

"spark-streaming-kafka-0-10_2.11-2.4.0.jar:kafka-clients-2.5.0.jar:metrics.properties:etl-gson-2.2.5.jar:guava-16.0.1.jar:hbase-common-2.1.0-cdh6.3.1.jar:hbase-hadoop2-compat-2.1.0-cdh6.3.1.jar:hbase-protocol-shaded-2.1.0-cdh6.3.1.jar:hbase-hadoop-compat-2.1.0-cdh6.3.1.jar:hbase-metrics-api-2.1.0-cdh6.3.1.jar:hamcrest-core-1.3.jar:hbase-shaded-protobuf-2.2.1.jar:hbase-protocol-2.1.0-cdh6.3.1.jar:hbase-shaded-netty-2.2.1.jar:hbase-metrics-2.1.0-cdh6.3.1.jar:joni-2.1.11.jar:error_prone_annotations-2.3.3.jar:junit-4.12.jar:hbase-client-2.1.0-cdh6.3.1.jar:jcodings-1.0.18.jar:hbase-shaded-miscellaneous-2.2.1.jar:spark-sql-patch-3.0.jar:spark-sql-kafka-0-10_2.11-2.4.0.jar",

"spark-streaming-kafka-0-10_2.11-2.4.0.jar:kafka-clients-2.5.0.jar:metrics.properties:etl-gson-2.2.5.jar:guava-16.0.1.jar:hbase-common-2.1.0-cdh6.3.1.jar:hbase-hadoop2-compat-2.1.0-cdh6.3.1.jar:hbase-protocol-shaded-2.1.0-cdh6.3.1.jar:hbase-hadoop-compat-2.1.0-cdh6.3.1.jar:hbase-metrics-api-2.1.0-cdh6.3.1.jar:hamcrest-core-1.3.jar:hbase-shaded-protobuf-2.2.1.jar:hbase-protocol-2.1.0-cdh6.3.1.jar:hbase-shaded-netty-2.2.1.jar:hbase-metrics-2.1.0-cdh6.3.1.jar:joni-2.1.11.jar:error_prone_annotations-2.3.3.jar:junit-4.12.jar:hbase-client-2.1.0-cdh6.3.1.jar:jcodings-1.0.18.jar:hbase-shaded-miscellaneous-2.2.1.jar:spark-sql-patch-4.0.jar:spark-sql-kafka-0-10_2.11-2.4.0.jar",