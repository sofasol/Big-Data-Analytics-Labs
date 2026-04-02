INSERT INTO dim_country (country_name)
SELECT DISTINCT customer_country FROM mock_data
UNION
SELECT DISTINCT seller_country FROM mock_data
UNION
SELECT DISTINCT store_country FROM mock_data
UNION
SELECT DISTINCT supplier_country FROM mock_data
ON CONFLICT (country_name) DO NOTHING;

INSERT INTO dim_city (city_name, country_id)
SELECT DISTINCT store_city, c.country_id
FROM mock_data m
JOIN dim_country c ON c.country_name = m.store_country
ON CONFLICT (city_name, country_id) DO NOTHING;

INSERT INTO dim_pet_type (pet_type_name)
SELECT DISTINCT customer_pet_type FROM mock_data
UNION
SELECT DISTINCT pet_category FROM mock_data
ON CONFLICT (pet_type_name) DO NOTHING;

INSERT INTO dim_brand (brand_name)
SELECT DISTINCT product_brand FROM mock_data
ON CONFLICT (brand_name) DO NOTHING;

INSERT INTO dim_category (product_category, pet_category)
SELECT DISTINCT product_category, pet_category FROM mock_data
ON CONFLICT (product_category, pet_category) DO NOTHING;

INSERT INTO dim_supplier (supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city_id, supplier_country_id)
SELECT DISTINCT ON (m.supplier_name)
    m.supplier_name,
    m.supplier_contact,
    m.supplier_email,
    m.supplier_phone,
    m.supplier_address,
    ci.city_id,
    co.country_id
FROM mock_data m
LEFT JOIN dim_city ci ON ci.city_name = m.supplier_city
LEFT JOIN dim_country co ON co.country_name = m.supplier_country
ON CONFLICT DO NOTHING;

INSERT INTO dim_store (store_name, store_location, store_city_id, store_state, store_phone, store_email)
SELECT DISTINCT ON (m.store_name)
    m.store_name,
    m.store_location,
    c.city_id,
    m.store_state,
    m.store_phone,
    m.store_email
FROM mock_data m
LEFT JOIN dim_city c ON c.city_name = m.store_city
ON CONFLICT DO NOTHING;

INSERT INTO dim_customer (customer_first_name, customer_last_name, customer_email, customer_age, customer_country_id, customer_postal_code, customer_city_id)
SELECT DISTINCT ON (m.customer_email)
    m.customer_first_name,
    m.customer_last_name,
    m.customer_email,
    m.customer_age::INT,
    co.country_id,
    m.customer_postal_code,
    c.city_id
FROM mock_data m
LEFT JOIN dim_country co ON co.country_name = m.customer_country
LEFT JOIN dim_city c ON c.city_name = m.store_city
ON CONFLICT (customer_email) DO NOTHING;

INSERT INTO dim_seller (seller_first_name, seller_last_name, seller_email, store_id, seller_city_id, seller_country_id)
SELECT DISTINCT ON (m.seller_email)
    m.seller_first_name,
    m.seller_last_name,
    m.seller_email,
    s.store_id,
    c.city_id,
    co.country_id
FROM mock_data m
JOIN dim_store s ON s.store_name = m.store_name
LEFT JOIN dim_city c ON c.city_name = m.store_city
LEFT JOIN dim_country co ON co.country_name = m.seller_country
ON CONFLICT DO NOTHING;

INSERT INTO dim_product (product_name, product_category_id, product_brand_id, product_price, supplier_id)
SELECT DISTINCT ON (m.product_name)
    m.product_name,
    cat.category_id,
    b.brand_id,
    m.product_price::DECIMAL,
    sup.supplier_id
FROM mock_data m
LEFT JOIN dim_category cat ON cat.product_category = m.product_category AND cat.pet_category = m.pet_category
LEFT JOIN dim_brand b ON b.brand_name = m.product_brand
LEFT JOIN dim_supplier sup ON sup.supplier_name = m.supplier_name
ON CONFLICT DO NOTHING;

INSERT INTO dim_pet (pet_name, pet_type_id, pet_breed, customer_id)
SELECT DISTINCT ON (m.customer_pet_name, m.customer_email)
    m.customer_pet_name,
    pt.pet_type_id,
    m.customer_pet_breed,
    c.customer_id
FROM mock_data m
JOIN dim_pet_type pt ON pt.pet_type_name = m.customer_pet_type
JOIN dim_customer c ON c.customer_email = m.customer_email
ON CONFLICT DO NOTHING;

INSERT INTO fact_sales (sale_date, customer_id, seller_id, product_id, store_id, quantity, total_price)
SELECT 
    m.sale_date::DATE,
    c.customer_id,
    sel.seller_id,
    p.product_id,
    s.store_id,
    m.sale_quantity::INT,
    m.sale_total_price::DECIMAL
FROM mock_data m
JOIN dim_customer c ON c.customer_email = m.customer_email
JOIN dim_seller sel ON sel.seller_email = m.seller_email
JOIN dim_product p ON p.product_name = m.product_name
JOIN dim_store s ON s.store_name = m.store_name;