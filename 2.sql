public List<String> getEdgeProperties(int id) throws DatabaseException {
        StoredProcedureCall<List<String>> sp = new StoredProcedureCall<>("GET_EDGE_ARGUMENTS_V2",
                resultSet -> {
                    List<String> edgeProp = new ArrayList<>();
                    edgeProp.add(resultSet.getString("edge_type"));
                    edgeProp.add(resultSet.getString("config"));
                    return edgeProp;
                }
        );
        sp.addParameter("EDGE_ID", id, Types.INTEGER);
        return executeQuery(sp).get(0);
    }

    public List<IngestionParams> getEdgeIngestionList(String edge) throws DatabaseException {
        StoredProcedureCall<IngestionParams> sp = new StoredProcedureCall<>("GET_FLOW_EDGE_INGESTION_VERSIONS",
                resultSet -> {
                    String version = resultSet.getString("version");
                    String cluster = resultSet.getString("cluster");
                    return new IngestionParams(version, cluster);
                }
        );
        sp.addParameter("EDGE_TYPE", edge, Types.INTEGER);
        return executeQuery(sp);
    }

    public List<JarWrapper> getFlowEdgesJars(String category, String version) throws DatabaseException {
        StoredProcedureCall<JarWrapper> sp = new StoredProcedureCall<JarWrapper>("GET_FLOW_EDGES_JARS_V2",
                resultSet -> {
                    String artifactId = resultSet.getString("artifact_id");
                    String path = resultSet.getString("path");
                    return new JarWrapper(artifactId, path, category);
                });
        sp.addParameter("CATEGORY", category, Types.VARCHAR);
        sp.addParameter("INGESTION_VERSION", version, Types.VARCHAR);
        return executeQuery(sp);
    }

    public ClassPathWrapper getDataClassPath(String version) throws DatabaseException {
        StoredProcedureCall<ClassPathWrapper> sp = new StoredProcedureCall<>("GET_SPARK_DATA_CLASSPATH",
                resultSet -> {
                String classPath = resultSet.getString("classpath");
                String category = resultSet.getString("category");
                return new ClassPathWrapper(classPath, category);
        });
        sp.addParameter("VERSION", version, Types.VARCHAR);
        return executeQuery(sp).get(0);
    }

    public Edge.IngestionConfigs getIngestionConfigs(String version) throws DatabaseException {
        StoredProcedureCall<Edge.IngestionConfigs> sp = new StoredProcedureCall<>("GET_FLOW_SPARK_INGESTION_CONFIGS",
                Edge.IngestionConfigs::getFromResultSet);
        sp.addParameter("VERSION", version, Types.VARCHAR);
        return executeQuery(sp).get(0);
    }

    public Edge.IngestionConfigs getIngestionConfigs(String cluster, String edge) throws DatabaseException {
        StoredProcedureCall<Edge.IngestionConfigs> sp = new StoredProcedureCall<>("GET_DEFAULT_SPARK_INGESTION_CONFIGS",
                Edge.IngestionConfigs::getFromResultSet);
        sp.addParameter("EDGE_TYPE", edge, Types.VARCHAR);
        sp.addParameter("CLUSTER", cluster, Types.VARCHAR);
        return executeQuery(sp).get(0);
    }

    public List<JarWrapper> getIngestionJars(String sparkProcessingJarVersion, String ruleServiceJarVersion, String extraJarsVersion) throws DatabaseException {
        StoredProcedureCall<JarWrapper> sp = new StoredProcedureCall<JarWrapper>("GET_FLOW_EDGE_INGESTION_JARS",
                resultSet -> {
                    String artifactId = resultSet.getString("artifact_id");
                    String path = resultSet.getString("path");
                    String category = resultSet.getString("category");
                    return new JarWrapper(artifactId, path, category);
                });
        sp.addParameter("SPARK_PROCESSING_JAR_VERSION", sparkProcessingJarVersion, Types.VARCHAR);
        sp.addParameter("RULE_SERVICE_JAR_VERSION", ruleServiceJarVersion, Types.VARCHAR);
        sp.addParameter("EXTRA_JARS_VERSION", extraJarsVersion, Types.VARCHAR);
        return executeQuery(sp);
    }

    public List<ClassPathWrapper> getIngestionClassPaths(String driverClassPathVersion, String executorClassPathVersion) throws DatabaseException {
        StoredProcedureCall<ClassPathWrapper> sp = new StoredProcedureCall<ClassPathWrapper>("GET_SPARK_INGESTION_CLASSPATHS",
                resultSet -> {
                    String classPath = resultSet.getString("data_classpath");
                    String category = resultSet.getString("category");
                    return new ClassPathWrapper(classPath, category);
                });
        sp.addParameter("DRIVER_CLASSPATH_VERSION", driverClassPathVersion, Types.VARCHAR);
        sp.addParameter("EXECUTOR_CLASSPATH_VERSION", executorClassPathVersion, Types.VARCHAR);
        return executeQuery(sp);
    }