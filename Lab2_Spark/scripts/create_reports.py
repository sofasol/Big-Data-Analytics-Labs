from pyspark.sql import SparkSession, functions as F
import requests
import socket

try:
    driver_host = socket.gethostbyname('jupyter_lab2')
except:
    driver_host = "0.0.0.0"

spark = SparkSession.builder \
    .appName("ClickHouse_Reporting_Job") \
    .master("spark://spark-master:7077") \
    .config("spark.driver.host", driver_host) \
    .config("spark.driver.bindAddress", "0.0.0.0") \
    .config("spark.executor.extraClassPath", "/opt/spark/drivers/*") \
    .config("spark.driver.extraClassPath", "/opt/spark/drivers/*") \
    .config("spark.jars", "/opt/spark/drivers/postgresql-42.7.1.jar") \
    .getOrCreate()

db_url = "jdbc:postgresql://postgres_lab2:5432/lab_db"
db_params = {
    "user": "postgres",
    "password": "postgres",
    "driver": "org.postgresql.Driver"
}

clickhouse_url = "http://clickhouse_lab2:8123/"
auth_params = {"user": "user", "password": "password"}

def ch_query(query):
    response = requests.post(clickhouse_url, params=auth_params, data=query)
    if response.status_code != 200:
        print(f"ClickHouse error: {response.text}")
    return response

# Чтение данных из PostgreSQL
df_fact = spark.read.jdbc(url=db_url, table="fact_sales", properties=db_params)
df_product = spark.read.jdbc(url=db_url, table="dim_product", properties=db_params)
df_customer = spark.read.jdbc(url=db_url, table="dim_customer", properties=db_params)
df_store = spark.read.jdbc(url=db_url, table="dim_store", properties=db_params)
df_supplier = spark.read.jdbc(url=db_url, table="dim_supplier", properties=db_params)
df_raw = spark.read.jdbc(url=db_url, table="mock_data", properties=db_params)

# Отчёт 1: продажи по продуктам
print("Report 1: product sales")
report1 = df_fact.join(df_product, "product_id").groupBy("product_id") \
    .agg(
        F.sum("sale_quantity").alias("total_qty"),
        F.sum("sale_total_price").alias("revenue"),
        F.round(F.avg("product_price"), 2).alias("avg_price"),
        F.first("product_name").alias("product_name"),
        F.first("product_category").alias("product_category")
    ).orderBy(F.desc("total_qty")).limit(10)

ch_query("DROP TABLE IF EXISTS reports.report_product_sales")
ch_query("CREATE TABLE reports.report_product_sales (product_name String, product_category String, total_qty Int64, revenue Float64, avg_price Float64) ENGINE = MergeTree() ORDER BY product_name")
for row in report1.collect():
    name = row.product_name.replace("'", "''")
    ch_query(f"INSERT INTO reports.report_product_sales VALUES ('{name}', '{row.product_category}', {row.total_qty}, {row.revenue}, {row.avg_price})")

# Отчёт 2: продажи по клиентам
print("Report 2: customer sales")
report2 = df_fact.join(df_customer, "customer_id").groupBy("customer_id") \
    .agg(
        F.sum("sale_total_price").alias("total_spent"),
        F.round(F.avg("sale_total_price"), 2).alias("avg_check"),
        F.first("customer_first_name").alias("first_name"),
        F.first("customer_last_name").alias("last_name"),
        F.first("customer_email").alias("email"),
        F.first("customer_country").alias("country")
    ).orderBy(F.desc("total_spent")).limit(10)

ch_query("DROP TABLE IF EXISTS reports.report_customer_sales")
ch_query("CREATE TABLE reports.report_customer_sales (first_name String, last_name String, email String, country String, total_spent Float64, avg_check Float64) ENGINE = MergeTree() ORDER BY email")
for row in report2.collect():
    fn = row.first_name.replace("'", "''")
    ln = row.last_name.replace("'", "''")
    ch_query(f"INSERT INTO reports.report_customer_sales VALUES ('{fn}', '{ln}', '{row.email}', '{row.country}', {row.total_spent}, {row.avg_check})")

# Отчёт 3: продажи по времени
print("Report 3: time sales")
report3 = df_fact.withColumn("year", F.year("sale_date")).withColumn("month", F.month("sale_date")) \
    .groupBy("year", "month").agg(
        F.sum("sale_total_price").alias("revenue"),
        F.count("sale_date").alias("order_count"),
        F.round(F.avg("sale_total_price"), 2).alias("avg_order_value")
    ).orderBy("year", "month")

ch_query("DROP TABLE IF EXISTS reports.report_time_sales")
ch_query("CREATE TABLE reports.report_time_sales (year Int32, month Int32, revenue Float64, order_count Int64, avg_order_value Float64) ENGINE = MergeTree() ORDER BY (year, month)")
for row in report3.collect():
    ch_query(f"INSERT INTO reports.report_time_sales VALUES ({row.year}, {row.month}, {row.revenue}, {row.order_count}, {row.avg_order_value})")

# Отчёт 4: продажи по магазинам
print("Report 4: store sales")
report4 = df_fact.join(df_store, "store_id").groupBy("store_id") \
    .agg(
        F.sum("sale_total_price").alias("revenue"),
        F.round(F.avg("sale_total_price"), 2).alias("avg_check"),
        F.first("store_name").alias("store_name"),
        F.first("store_city").alias("store_city"),
        F.first("store_country").alias("store_country")
    ).orderBy(F.desc("revenue")).limit(5)

ch_query("DROP TABLE IF EXISTS reports.report_store_sales")
ch_query("CREATE TABLE reports.report_store_sales (store_name String, city String, country String, revenue Float64, avg_check Float64) ENGINE = MergeTree() ORDER BY store_name")
for row in report4.collect():
    name = row.store_name.replace("'", "''")
    city = row.store_city.replace("'", "''")
    ch_query(f"INSERT INTO reports.report_store_sales VALUES ('{name}', '{city}', '{row.store_country}', {row.revenue}, {row.avg_check})")

# Отчёт 5: продажи по поставщикам
print("Report 5: supplier sales")
report5 = df_fact.join(df_product, "product_id").join(df_supplier, "supplier_id").groupBy("supplier_id") \
    .agg(
        F.sum("sale_total_price").alias("revenue"),
        F.round(F.avg("product_price"), 2).alias("avg_price"),
        F.first("supplier_name").alias("supplier_name"),
        F.first("supplier_country").alias("supplier_country")
    ).orderBy(F.desc("revenue")).limit(5)

ch_query("DROP TABLE IF EXISTS reports.report_supplier_sales")
ch_query("CREATE TABLE reports.report_supplier_sales (supplier_name String, country String, revenue Float64, avg_price Float64) ENGINE = MergeTree() ORDER BY supplier_name")
for row in report5.collect():
    name = row.supplier_name.replace("'", "''")
    ch_query(f"INSERT INTO reports.report_supplier_sales VALUES ('{name}', '{row.supplier_country}', {row.revenue}, {row.avg_price})")

# Отчёт 6: качество продуктов
print("Report 6: product quality")
report6 = df_raw.groupBy("product_name") \
    .agg(
        F.round(F.avg("product_rating"), 2).alias("avg_rating"),
        F.sum("product_reviews").cast("long").alias("total_reviews"),
        F.first("product_category").alias("category")
    ).orderBy(F.desc("avg_rating"))

ch_query("DROP TABLE IF EXISTS reports.report_product_quality")
ch_query("CREATE TABLE reports.report_product_quality (product_name String, category String, avg_rating Float64, total_reviews Int64) ENGINE = MergeTree() ORDER BY avg_rating")
for row in report6.collect():
    name = row.product_name.replace("'", "''")
    ch_query(f"INSERT INTO reports.report_product_quality VALUES ('{name}', '{row.category}', {row.avg_rating}, {row.total_reviews})")

print("All 6 reports written to ClickHouse successfully.")
spark.stop()