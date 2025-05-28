INSERT INTO dim_country (country_name)
SELECT DISTINCT customer_country
FROM mock_data
WHERE customer_country IS NOT NULL
ON CONFLICT (country_name) DO NOTHING;

INSERT INTO dim_country (country_name)
SELECT DISTINCT seller_country
FROM mock_data
WHERE seller_country IS NOT NULL
ON CONFLICT (country_name) DO NOTHING;

INSERT INTO dim_postal_code (postal_code, country_id)
SELECT DISTINCT
    customer_postal_code,
    c.country_id
FROM mock_data m
JOIN dim_country c ON m.customer_country = c.country_name
WHERE customer_postal_code IS NOT NULL
ON CONFLICT (postal_code) DO NOTHING;

INSERT INTO dim_postal_code (postal_code, country_id)
SELECT DISTINCT
    seller_postal_code,
    c.country_id
FROM mock_data m
JOIN dim_country c ON m.seller_country = c.country_name
WHERE seller_postal_code IS NOT NULL
ON CONFLICT (postal_code) DO NOTHING;

INSERT INTO dim_customer (
    customer_id, first_name, last_name, age, email, country_id, postal_code
)
SELECT DISTINCT
    sale_customer_id,
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    c.country_id,
    m.customer_postal_code
FROM mock_data m
LEFT JOIN dim_country c ON m.customer_country = c.country_name
WHERE sale_customer_id IS NOT NULL
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO dim_pet_type (pet_type_name)
SELECT DISTINCT customer_pet_type
FROM mock_data
WHERE customer_pet_type IS NOT NULL
ON CONFLICT (pet_type_name) DO NOTHING;

INSERT INTO dim_pet_category (pet_category_name)
SELECT DISTINCT pet_category
FROM mock_data
WHERE pet_category IS NOT NULL
ON CONFLICT (pet_category_name) DO NOTHING;

INSERT INTO dim_pet_breed (pet_breed_name, pet_type_id)
SELECT DISTINCT
    m.customer_pet_breed,
    pt.pet_type_id
FROM mock_data m
JOIN dim_pet_type pt ON m.customer_pet_type = pt.pet_type_name
WHERE m.customer_pet_breed IS NOT NULL
ON CONFLICT (pet_breed_name) DO NOTHING;

INSERT INTO dim_customer_pet (customer_id, pet_name, pet_type_id, pet_breed_id, pet_category_id)
SELECT
    c.customer_id,
    m.customer_pet_name,
    pt.pet_type_id,
    pb.pet_breed_id,
    pc.pet_category_id
FROM mock_data m
JOIN dim_customer c ON c.customer_id = m.sale_customer_id
LEFT JOIN dim_pet_type pt ON m.customer_pet_type = pt.pet_type_name
LEFT JOIN dim_pet_breed pb ON m.customer_pet_breed = pb.pet_breed_name
LEFT JOIN dim_pet_category pc ON m.pet_category = pc.pet_category_name;

INSERT INTO dim_seller (
    seller_id, first_name, last_name, email, country_id, postal_code
)
SELECT DISTINCT
    sale_seller_id,
    seller_first_name,
    seller_last_name,
    seller_email,
    c.country_id,
    m.seller_postal_code
FROM mock_data m
LEFT JOIN dim_country c ON m.seller_country = c.country_name
WHERE sale_seller_id IS NOT NULL
ON CONFLICT (seller_id) DO NOTHING;

INSERT INTO dim_category (category_name)
SELECT DISTINCT product_category
FROM mock_data
WHERE product_category IS NOT NULL
ON CONFLICT (category_name) DO NOTHING;

INSERT INTO dim_brand (brand_name)
SELECT DISTINCT product_brand
FROM mock_data
WHERE product_brand IS NOT NULL
ON CONFLICT (brand_name) DO NOTHING;

INSERT INTO dim_product (
    product_id, name, category_id, price, quantity, weight,
    brand_id, description, rating, reviews, release_date, expiry_date
)
SELECT DISTINCT
    sale_product_id,
    product_name,
    cat.category_id,
    product_price,
    product_quantity,
    product_weight,
    br.brand_id,
    product_description,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date
FROM mock_data m
LEFT JOIN dim_category cat ON m.product_category = cat.category_name
LEFT JOIN dim_brand br ON m.product_brand = br.brand_name
ON CONFLICT (product_id) DO NOTHING;

INSERT INTO dim_supplier (
    name, contact, email, phone, address, city, country
)
SELECT DISTINCT
    supplier_name, supplier_contact, supplier_email, supplier_phone,
    supplier_address, supplier_city, supplier_country
FROM mock_data
WHERE supplier_name IS NOT NULL
  AND supplier_city IS NOT NULL
  AND supplier_country IS NOT NULL;

INSERT INTO dim_store (
    name, location, city, state, country, phone, email
)
SELECT DISTINCT
    store_name, store_location, store_city, store_state,
    store_country, store_phone, store_email
FROM mock_data
WHERE store_name IS NOT NULL
  AND store_city IS NOT NULL
  AND store_country IS NOT NULL;

INSERT INTO fact_sales (
    sale_id, customer_id, seller_id, product_id, supplier_id,
    store_id, sale_date, quantity, total_price
)
SELECT
    m.id,
    c.customer_id,
    s.seller_id,
    p.product_id,
    sup.supplier_id,
    st.store_id,
    m.sale_date,
    m.sale_quantity,
    m.sale_total_price
FROM mock_data m
LEFT JOIN dim_customer c ON m.sale_customer_id = c.customer_id
LEFT JOIN dim_seller s ON m.sale_seller_id = s.seller_id
LEFT JOIN dim_product p ON m.sale_product_id = p.product_id
LEFT JOIN dim_store st ON
    m.store_name = st.name AND
    m.store_city = st.city AND
    m.store_country = st.country
LEFT JOIN dim_supplier sup ON
    m.supplier_name = sup.name AND
    m.supplier_city = sup.city AND
    m.supplier_country = sup.country
ON CONFLICT (sale_id) DO NOTHING;
