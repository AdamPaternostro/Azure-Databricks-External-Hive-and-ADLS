# Azure-Databricks-External-Hive-and-ADLS
Shows how to use an External Hive (SQL Server) along with ADLS Gen 1 as part of a Databricks initialization script that runs when the cluster is created.

### Stpes
1. Create an Azure Databrick Workspace in the Azure portal
2. Open the workspace and click on your name
3. Then select User Settings
4. Create a new token (save the value)
5. Download Databricks CLI https://docs.databricks.com/user-guide/dev-tools/databricks-cli.html
6. Configure CLI ```databricks configure --token```
7. Update the values in the external-metastore.sh
  * This assumes you have a Hive metastore in SQL Server, a ADLS Gen 1 account and a Service Principle
  * You can create an HDI Cluster and let that create your metastore
  * Please check your Hive version and update the external-metastore.sh
  * The external-metastore.sh tells Databricks not to check the schema (validation)
8. Upload the external metastore (run the lines below)

```
dbfs mkdirs dbfs:/databricks/init/
dbfs rm dbfs:/databricks/init/external-metastore.sh
dbfs cp external-metastore.sh dbfs:/databricks/init/external-metastore.sh
```


### To Test ADLS (run this in notebook)
This assume you have a file (CSV to view or just do a directory listing)
```
%scala
dbutils.fs.ls("adl://YOUR-DATA-LAKE-HERE.azuredatalakestore.net/states")
val df = spark.read.text("adl://YOUR-DATA-LAKE-HERE.azuredatalakestore.net/DIRECTORY-PATH/SAMPLE-FILE.csv")
df.show()
```

### To Test External Hive (run this in notebook)
```
%sql
show tables;
```


### Reference
https://docs.databricks.com/user-guide/advanced/external-hive-metastore.html
