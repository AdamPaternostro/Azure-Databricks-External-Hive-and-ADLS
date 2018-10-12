#!/bin/sh
# Loads environment variables to determine the correct JDBC driver to use.
source /etc/environment
# Configure External Hive and ADLS Gen 1
cat << 'EOF' > /databricks/driver/conf/00-custom-spark.conf
[driver] {
    "spark.hadoop.javax.jdo.option.ConnectionURL" = "jdbc:sqlserver://REPLACE-ME.database.windows.net:1433;database=REPLACE-ME;encrypt=true;trustServerCertificate=true;create=false;loginTimeout=300"
    "spark.hadoop.javax.jdo.option.ConnectionUserName" = "REPLACE-ME"
    "spark.hadoop.javax.jdo.option.ConnectionPassword" = "REPLACE-ME"
    "spark.hadoop.javax.jdo.option.ConnectionDriverName" = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
    "spark.sql.hive.metastore.jars" = "maven"
    "spark.sql.hive.metastore.version" = "2.1.1"
    "hive.metastore.schema.verification" = "false"
    "hive.metastore.schema.verification.record.version" = "true"
    "spark.hadoop.dfs.adls.oauth2.access.token.provider.type" = "ClientCredential"
    "spark.hadoop.dfs.adls.oauth2.client.id" = "REPLACE-ME"
    "spark.hadoop.dfs.adls.oauth2.credential" = "REPLACE-ME"
    "spark.hadoop.dfs.adls.oauth2.refresh.url " = "https://login.microsoftonline.com/REPLACE-ME-SUBSCRIPTION-ID/oauth2/token"
    }
EOF