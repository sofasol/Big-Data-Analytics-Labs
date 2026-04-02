CREATE TABLE IF NOT EXISTS dim_country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_city (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    country_id INT NOT NULL REFERENCES dim_country(country_id),
    UNIQUE(city_name, country_id)
);

CREATE TABLE IF NOT EXISTS dim_pet_type (
    pet_type_id SERIAL PRIMARY KEY,
    pet_type_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_brand (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_category (
    category_id SERIAL PRIMARY KEY,
    product_category VARCHAR(100) NOT NULL,
    pet_category VARCHAR(100) NOT NULL,
    UNIQUE(product_category, pet_category)
);

CREATE TABLE IF NOT EXISTS dim_supplier (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR NOT NULL,
    supplier_contact VARCHAR,
    supplier_email VARCHAR,
    supplier_phone VARCHAR,
    supplier_address TEXT,
    supplier_city_id INT REFERENCES dim_city(city_id),
    supplier_country_id INT REFERENCES dim_country(country_id)
);

CREATE TABLE IF NOT EXISTS dim_store (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR NOT NULL,
    store_location VARCHAR,
    store_city_id INT REFERENCES dim_city(city_id),
    store_state VARCHAR,
    store_phone VARCHAR,
    store_email VARCHAR
);

CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id SERIAL PRIMARY KEY,
    customer_first_name VARCHAR,
    customer_last_name VARCHAR,
    customer_email VARCHAR UNIQUE,
    customer_age INT,
    customer_country_id INT REFERENCES dim_country(country_id),
    customer_postal_code VARCHAR,
    customer_city_id INT REFERENCES dim_city(city_id)
);

CREATE TABLE IF NOT EXISTS dim_seller (
    seller_id SERIAL PRIMARY KEY,
    seller_first_name VARCHAR,
    seller_last_name VARCHAR,
    seller_email VARCHAR UNIQUE,
    store_id INT REFERENCES dim_store(store_id),
    seller_city_id INT REFERENCES dim_city(city_id),
    seller_country_id INT REFERENCES dim_country(country_id)
);

CREATE TABLE IF NOT EXISTS dim_product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR NOT NULL,
    product_category_id INT REFERENCES dim_category(category_id),
    product_brand_id INT REFERENCES dim_brand(brand_id),
    product_price DECIMAL(10,2),
    supplier_id INT REFERENCES dim_supplier(supplier_id)
);

CREATE TABLE IF NOT EXISTS dim_pet (
    pet_id SERIAL PRIMARY KEY,
    pet_name VARCHAR,
    pet_type_id INT REFERENCES dim_pet_type(pet_type_id),
    pet_breed VARCHAR,
    customer_id INT REFERENCES dim_customer(customer_id)
);

CREATE TABLE IF NOT EXISTS fact_sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE,
    customer_id INT REFERENCES dim_customer(customer_id),
    seller_id INT REFERENCES dim_seller(seller_id),
    product_id INT REFERENCES dim_product(product_id),
    store_id INT REFERENCES dim_store(store_id),
    quantity INT,
    total_price DECIMAL(12,2)
);