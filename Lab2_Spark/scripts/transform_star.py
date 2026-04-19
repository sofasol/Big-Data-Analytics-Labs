from pyspark.sql import SparkSession, functions as F
import socket

driver_host = socket.gethostbyname('jupyter_lab2')
spark = SparkSession.builder \
    .appName("ETL_Star_Postgres") \
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

df = spark.read.jdbc(url=db_url, table="mock_data", properties=db_params)

# 1. Измерение "supplier" (все поля о поставщике)
dim_supplier = df.select(
    "supplier_name", "supplier_contact", "supplier_email",
    "supplier_phone", "supplier_address", "supplier_city", "supplier_country"
).dropDuplicates(["supplier_name"]) \
 .withColumn("supplier_id", F.monotonically_increasing_id())

# 2. Измерение "store" (все поля о магазине)
dim_store = df.select(
    "store_name", "store_location", "store_city", "store_state",
    "store_country", "store_phone", "store_email"
).dropDuplicates(["store_name"]) \
 .withColumn("store_id", F.monotonically_increasing_id())

# 3. Измерение "customer" (все поля о покупателе + питомец)
dim_customer = df.select(
    "customer_first_name", "customer_last_name", "customer_email",
    "customer_age", "customer_country", "customer_postal_code",
    "customer_pet_type", "customer_pet_name", "customer_pet_breed"
).dropDuplicates(["customer_email"]) \
 .withColumn("customer_id", F.monotonically_increasing_id())

# 4. Измерение "seller" (все поля о продавце)
dim_seller = df.select(
    "seller_first_name", "seller_last_name", "seller_email",
    "seller_country", "seller_postal_code"
).dropDuplicates(["seller_email"]) \
 .withColumn("seller_id", F.monotonically_increasing_id())

# 5. Измерение "product" (все поля о товаре + связь с поставщиком)
dim_product = df.join(dim_supplier, "supplier_name") \
    .select(
        "product_name", "product_category", "product_brand", "product_price",
        "product_weight", "product_color", "product_size", "product_material",
        "product_description", "product_rating", "product_reviews",
        "product_release_date", "product_expiry_date", "pet_category",
        "supplier_id"
    ).dropDuplicates(["product_name", "product_brand"]) \
     .withColumn("product_id", F.monotonically_increasing_id())

# 6. Таблица фактов
fact_sales = df.alias("raw") \
    .join(dim_customer.alias("c"), "customer_email") \
    .join(dim_seller.alias("sel"), "seller_email") \
    .join(dim_product.alias("p"), ["product_name", "product_brand"]) \
    .join(dim_store.alias("st"), "store_name") \
    .select(
        F.col("raw.sale_date").cast("date"),
        F.col("raw.sale_quantity").cast("int"),
        F.col("raw.sale_total_price").cast("decimal(18,2)"),
        F.col("c.customer_id"),
        F.col("sel.seller_id"),
        F.col("p.product_id"),
        F.col("st.store_id")
    )

# Запись всех таблиц в PostgreSQL
tables = {
    "dim_supplier": dim_supplier,
    "dim_store": dim_store,
    "dim_customer": dim_customer,
    "dim_seller": dim_seller,
    "dim_product": dim_product,
    "fact_sales": fact_sales
}

for name, table_df in tables.items():
    table_df.write.jdbc(url=db_url, table=name, mode="overwrite", properties=db_params)
    print(f"Table {name} written successfully.")

spark.stop()