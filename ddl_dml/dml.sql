WITH bounds AS (
  SELECT 
    MIN(TO_DATE(sale_date, 'MM/DD/YYYY')) AS min_date,
    MAX(TO_DATE(sale_date, 'MM/DD/YYYY')) AS max_date
  FROM mock_data
), dates AS (
  SELECT generate_series(bounds.min_date, bounds.max_date, '1 day')::date AS dt
  FROM bounds
)
INSERT INTO dim_date (date_key, full_date, year, quarter, month, day, weekday)
SELECT
  TO_CHAR(dt, 'YYYYMMDD')::INTEGER,
  dt,
  EXTRACT(YEAR FROM dt)::INT,
  EXTRACT(QUARTER FROM dt)::INT,
  EXTRACT(MONTH FROM dt)::INT,
  EXTRACT(DAY FROM dt)::INT,
  TO_CHAR(dt, 'FMDay')
FROM dates;

INSERT INTO dim_customer (
  customer_src_id, first_name, last_name, age, email,
  country, postal_code, pet_type, pet_name, pet_breed
)
SELECT DISTINCT
  sale_customer_id::BIGINT,
  customer_first_name,
  customer_last_name,
  customer_age::INT,
  customer_email,
  customer_country,
  customer_postal_code,
  customer_pet_type,
  customer_pet_name,
  customer_pet_breed
FROM mock_data
WHERE sale_customer_id IS NOT NULL
ON CONFLICT (customer_src_id) DO NOTHING;


INSERT INTO dim_seller (
  seller_src_id, first_name, last_name, email, country, postal_code
)
SELECT DISTINCT
  sale_seller_id::BIGINT,
  seller_first_name, seller_last_name, seller_email,
  seller_country, seller_postal_code
FROM mock_data
WHERE sale_seller_id IS NOT NULL
ON CONFLICT (seller_src_id) DO NOTHING;


INSERT INTO dim_supplier (name)
SELECT DISTINCT supplier_name
FROM mock_data
WHERE supplier_name IS NOT NULL;

INSERT INTO dim_store (name)
SELECT DISTINCT store_name
FROM mock_data
WHERE store_name IS NOT NULL
ON CONFLICT (name) DO NOTHING;


INSERT INTO dim_product (
  product_src_id, name, category, price, weight, color, size,
  brand, material, description, rating, reviews, release_date, expiry_date
)
SELECT DISTINCT
  sale_product_id::BIGINT,
  product_name,
  product_category,
  product_price,
  product_weight,
  product_color,
  product_size,
  product_brand,
  product_material,
  product_description,
  product_rating,
  product_reviews,
  TO_DATE(product_release_date, 'MM/DD/YYYY'),
  TO_DATE(product_expiry_date, 'MM/DD/YYYY')
FROM mock_data
WHERE sale_product_id IS NOT NULL
ON CONFLICT (product_src_id) DO NOTHING;

WITH cleaned AS (
  SELECT
    TO_DATE(sale_date, 'MM/DD/YYYY') AS sale_dt,
    TO_CHAR(TO_DATE(sale_date,'MM/DD/YYYY'),'YYYYMMDD')::INT AS sale_dk,
    sale_customer_id,
    sale_seller_id,
    sale_product_id,
    sale_quantity,
    product_price,
    sale_total_price,
    supplier_name,
    store_name
  FROM mock_data
)
INSERT INTO fact_sales (
  date_key, customer_key, seller_key, supplier_key, store_key,
  product_key, quantity, unit_price, total_price
)
SELECT
  d.date_key,
  c.customer_key,
  s.seller_key,
  sup.supplier_key,
  st.store_key,
  p.product_key,
  cl.sale_quantity,
  cl.product_price,
  cl.sale_total_price
FROM cleaned cl
JOIN dim_date d
  ON d.date_key = cl.sale_dk
JOIN dim_customer c
  ON c.customer_src_id = cl.sale_customer_id
JOIN dim_seller s
  ON s.seller_src_id = cl.sale_seller_id
LEFT JOIN dim_supplier sup
  ON sup.name = cl.supplier_name
LEFT JOIN dim_store st
  ON st.name = cl.store_name
JOIN dim_product p
  ON p.product_src_id = cl.sale_product_id;

