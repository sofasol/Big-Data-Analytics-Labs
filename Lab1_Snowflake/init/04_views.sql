-- cводка по всем таблицам 
CREATE OR REPLACE VIEW view_schema_summary AS
SELECT 'dim_country' as table_name, COUNT(*) as row_count FROM dim_country
UNION ALL
SELECT 'dim_city', COUNT(*) FROM dim_city
UNION ALL
SELECT 'dim_pet_type', COUNT(*) FROM dim_pet_type
UNION ALL
SELECT 'dim_brand', COUNT(*) FROM dim_brand
UNION ALL
SELECT 'dim_category', COUNT(*) FROM dim_category
UNION ALL
SELECT 'dim_supplier', COUNT(*) FROM dim_supplier
UNION ALL
SELECT 'dim_store', COUNT(*) FROM dim_store
UNION ALL
SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION ALL
SELECT 'dim_seller', COUNT(*) FROM dim_seller
UNION ALL
SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL
SELECT 'dim_pet', COUNT(*) FROM dim_pet
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM fact_sales
ORDER BY table_name;

-- выручка по странам магазинов
CREATE OR REPLACE VIEW view_revenue_by_country AS
SELECT 
    co.country_name,
    COUNT(DISTINCT s.store_id) as stores_count,
    COUNT(f.sale_id) as sales_count,
    SUM(f.quantity) as total_items_sold,
    SUM(f.total_price) as total_revenue
FROM fact_sales f
JOIN dim_store s ON f.store_id = s.store_id
JOIN dim_city ci ON s.store_city_id = ci.city_id
JOIN dim_country co ON ci.country_id = co.country_id
GROUP BY co.country_name
ORDER BY total_revenue DESC;

--Топ брендов по выручке
CREATE OR REPLACE VIEW view_top_brands AS
SELECT 
    b.brand_name,
    COUNT(f.sale_id) as sales_count,
    SUM(f.quantity) as total_items_sold,
    SUM(f.total_price) as total_revenue
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_brand b ON p.product_brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY total_revenue DESC;