CREATE TABLE IF NOT EXISTS mock_data (
    id INT NOT NULL,
    customer_first_name VARCHAR(100) NOT NULL,
    customer_last_name VARCHAR(100) NOT NULL,
    customer_age INT NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    customer_country VARCHAR(100) NOT NULL,
    customer_postal_code VARCHAR(50),
    customer_pet_type VARCHAR(50) NOT NULL,
    customer_pet_name VARCHAR(100) NOT NULL,
    customer_pet_breed VARCHAR(100) NOT NULL,
    seller_first_name VARCHAR(100) NOT NULL,
    seller_last_name VARCHAR(100) NOT NULL,
    seller_email VARCHAR(255) NOT NULL,
    seller_country VARCHAR(100) NOT NULL,
    seller_postal_code VARCHAR(50),
    product_name VARCHAR(255) NOT NULL,
    product_category VARCHAR(100) NOT NULL,
    product_price NUMERIC(10,2) NOT NULL,
    product_quantity INT NOT NULL,
    sale_date DATE NOT NULL,
    sale_customer_id INT NOT NULL,
    sale_seller_id INT NOT NULL,
    sale_product_id INT NOT NULL,
    sale_quantity INT NOT NULL,
    sale_total_price NUMERIC(10,2) NOT NULL,
    store_name VARCHAR(255) NOT NULL,
    store_location VARCHAR(100) NOT NULL,
    store_city VARCHAR(100) NOT NULL,
    store_state VARCHAR(50),
    store_country VARCHAR(100) NOT NULL,
    store_phone VARCHAR(50) NOT NULL,
    store_email VARCHAR(255) NOT NULL,
    pet_category VARCHAR(100) NOT NULL,
    product_weight NUMERIC(10,2) NOT NULL,
    product_color VARCHAR(50) NOT NULL,
    product_size VARCHAR(50) NOT NULL,
    product_brand VARCHAR(100) NOT NULL,
    product_material VARCHAR(100) NOT NULL,
    product_description TEXT NOT NULL,
    product_rating NUMERIC(3,1) NOT NULL,
    product_reviews INT NOT NULL,
    product_release_date DATE NOT NULL,
    product_expiry_date DATE NOT NULL,
    supplier_name VARCHAR(255) NOT NULL,
    supplier_contact VARCHAR(255) NOT NULL,
    supplier_email VARCHAR(255) NOT NULL,
    supplier_phone VARCHAR(50) NOT NULL,
    supplier_address VARCHAR(255) NOT NULL,
    supplier_city VARCHAR(100) NOT NULL,
    supplier_country VARCHAR(100) NOT NULL
);

COPY mock_data FROM '/data/MOCK_DATA.csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (1).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (2).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (3).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (4).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (5).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (6).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (7).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (8).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (9).csv' DELIMITER ',' CSV HEADER;