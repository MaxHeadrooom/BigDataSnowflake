INSERT INTO dim_date (full_date)
SELECT DISTINCT to_date(sale_date, 'MM/DD/YYYY')
FROM mock_data_subset
WHERE sale_date IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_date (full_date)
SELECT DISTINCT to_date(product_release_date, 'MM/DD/YYYY')
FROM mock_data_subset
WHERE product_release_date IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_date (full_date)
SELECT DISTINCT to_date(product_expiry_date, 'MM/DD/YYYY')
FROM mock_data_subset
WHERE product_expiry_date IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_person_name (first_name, last_name)
SELECT DISTINCT customer_first_name, customer_last_name
FROM mock_data_subset
WHERE customer_first_name IS NOT NULL
  AND customer_last_name IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_person_name (first_name, last_name)
SELECT DISTINCT seller_first_name, seller_last_name
FROM mock_data_subset
WHERE seller_first_name IS NOT NULL
  AND seller_last_name IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_country (country_name)
SELECT DISTINCT customer_country
FROM mock_data_subset
WHERE customer_country IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_country (country_name)
SELECT DISTINCT seller_country
FROM mock_data_subset
WHERE seller_country IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_postal_code (postal_code, country_id)
SELECT DISTINCT
  m.customer_postal_code,
  c.country_id
FROM mock_data_subset m
JOIN dim_country c ON m.customer_country = c.country_name
WHERE m.customer_postal_code IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_postal_code (postal_code, country_id)
SELECT DISTINCT
  m.seller_postal_code,
  c.country_id
FROM mock_data_subset m
JOIN dim_country c ON m.seller_country = c.country_name
WHERE m.seller_postal_code IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_city (city_name, state, country_id)
SELECT DISTINCT
  m.store_city,
  m.store_state,
  c.country_id
FROM mock_data_subset m
JOIN dim_country c ON m.store_country = c.country_name
WHERE m.store_city IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_category (category_name)
SELECT DISTINCT product_category
FROM mock_data_subset
WHERE product_category IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_brand (brand_name)
SELECT DISTINCT product_brand
FROM mock_data_subset
WHERE product_brand IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_color (color_name)
SELECT DISTINCT product_color
FROM mock_data_subset
WHERE product_color IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_size (size_name)
SELECT DISTINCT product_size
FROM mock_data_subset
WHERE product_size IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_material (material_name)
SELECT DISTINCT product_material
FROM mock_data_subset
WHERE product_material IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_pet_type (pet_type_name)
SELECT DISTINCT customer_pet_type
FROM mock_data_subset
WHERE customer_pet_type IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_pet_category (pet_category_name)
SELECT DISTINCT pet_category
FROM mock_data_subset
WHERE pet_category IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_pet_breed (pet_breed_name, pet_type_id, pet_category_id)
SELECT DISTINCT
  m.customer_pet_breed,
  pt.pet_type_id,
  pc.pet_category_id
FROM mock_data_subset m
JOIN dim_pet_type pt ON m.customer_pet_type = pt.pet_type_name
JOIN dim_pet_category pc ON m.pet_category = pc.pet_category_name
WHERE m.customer_pet_breed IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_customer (customer_id, name_id, age, email, country_id, postal_code)
SELECT DISTINCT
  sale_customer_id,
  pn.name_id,
  customer_age,
  customer_email,
  c.country_id,
  m.customer_postal_code
FROM mock_data_subset m
LEFT JOIN dim_person_name pn
  ON m.customer_first_name = pn.first_name
 AND m.customer_last_name  = pn.last_name
LEFT JOIN dim_country c ON m.customer_country = c.country_name
WHERE sale_customer_id IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_customer_pet (customer_id, pet_name, pet_type_id, pet_breed_id, pet_category_id)
SELECT
  m.sale_customer_id,
  m.customer_pet_name,
  pt.pet_type_id,
  pb.pet_breed_id,
  pc.pet_category_id
FROM mock_data_subset m
LEFT JOIN dim_pet_type pt ON m.customer_pet_type = pt.pet_type_name
LEFT JOIN dim_pet_breed pb ON m.customer_pet_breed = pb.pet_breed_name
LEFT JOIN dim_pet_category pc ON m.pet_category = pc.pet_category_name
WHERE m.sale_customer_id IS NOT NULL;

INSERT INTO dim_seller (seller_id, name_id, email, country_id, postal_code)
SELECT DISTINCT
  sale_seller_id,
  pn.name_id,
  seller_email,
  c.country_id,
  m.seller_postal_code
FROM mock_data_subset m
LEFT JOIN dim_person_name pn
  ON m.seller_first_name = pn.first_name
 AND m.seller_last_name  = pn.last_name
LEFT JOIN dim_country c ON m.seller_country = c.country_name
WHERE sale_seller_id IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_supplier (name, contact, email, phone, address, city_id)
SELECT DISTINCT
  supplier_name,
  supplier_contact,
  supplier_email,
  supplier_phone,
  supplier_address,
  city.city_id
FROM mock_data_subset m
JOIN dim_city city ON m.supplier_city = city.city_name
WHERE supplier_name IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_store (name, location, city_id, phone, email)
SELECT DISTINCT
  store_name,
  store_location,
  city.city_id,
  store_phone,
  store_email
FROM mock_data_subset m
JOIN dim_city city ON m.store_city = city.city_name
WHERE store_name IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_product (product_id, name, category_id, price, quantity, weight, color_id, size_id, brand_id, material_id, rating)
SELECT DISTINCT
  sale_product_id,
  product_name,
  cat.category_id,
  product_price,
  product_quantity,
  product_weight,
  col.color_id,
  sz.size_id,
  br.brand_id,
  mat.material_id,
  product_rating
FROM mock_data_subset m
LEFT JOIN dim_category cat ON m.product_category = cat.category_name
LEFT JOIN dim_color col    ON m.product_color    = col.color_name
LEFT JOIN dim_size sz      ON m.product_size     = sz.size_name
LEFT JOIN dim_brand br     ON m.product_brand    = br.brand_name
LEFT JOIN dim_material mat ON m.product_material = mat.material_name
WHERE sale_product_id IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_product_dates (product_id, release_date_id, expiry_date_id)
SELECT
  m.sale_product_id,
  dr.date_id,
  de.date_id
FROM mock_data_subset m
LEFT JOIN dim_date dr ON to_date(m.product_release_date, 'MM/DD/YYYY') = dr.full_date
LEFT JOIN dim_date de ON to_date(m.product_expiry_date, 'MM/DD/YYYY') = de.full_date
WHERE m.sale_product_id IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO dim_product_texts (product_id, description, reviews)
SELECT DISTINCT
  sale_product_id,
  product_description,
  product_reviews
FROM mock_data_subset
WHERE sale_product_id IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO fact_sales (
    sale_id,
    customer_id,
    seller_id,
    product_id,
    supplier_id,
    store_id,
    sale_date_id,
    quantity,
    total_price
)
SELECT
    m.id,
    c.customer_id,
    s.seller_id,
    p.product_id,
    sup.supplier_id,
    st.store_id,
    d.date_id,
    m.sale_quantity,
    m.sale_total_price
FROM mock_data_subset m
LEFT JOIN dim_customer c ON m.sale_customer_id = c.customer_id
LEFT JOIN dim_seller   s ON m.sale_seller_id   = s.seller_id
LEFT JOIN dim_product  p ON m.sale_product_id  = p.product_id
LEFT JOIN dim_supplier sup ON m.supplier_name = sup.name
LEFT JOIN dim_store     st ON m.store_name    = st.name
LEFT JOIN dim_city      city ON m.store_city  = city.city_name
LEFT JOIN dim_date      d ON to_date(m.sale_date, 'MM/DD/YYYY') = d.full_date
ON CONFLICT DO NOTHING;
