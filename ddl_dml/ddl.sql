CREATE TABLE dim_customer (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INTEGER,
    email VARCHAR(100),
    country_name VARCHAR(50),
    postal_code VARCHAR(20)
);

CREATE TABLE dim_seller (
    seller_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    country_name VARCHAR(50),
    postal_code VARCHAR(20)
);

CREATE TABLE dim_product (
    product_id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    category_name VARCHAR(50),
    price NUMERIC,
    quantity INTEGER,
    weight NUMERIC,
    brand_name VARCHAR(50),
    description TEXT,
    rating NUMERIC,
    reviews TEXT,
    release_date VARCHAR(50),
    expiry_date VARCHAR(50)
);

CREATE TABLE dim_supplier (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    contact VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(50),
    address VARCHAR(100),
    city VARCHAR(50),
    country_name VARCHAR(50)
);

CREATE TABLE dim_store (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country_name VARCHAR(50),
    phone VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE dim_customer_pet (
    customer_id INTEGER,
    pet_name VARCHAR(50),
    pet_type_name VARCHAR(50),
    pet_breed_name VARCHAR(50),
    pet_category_name VARCHAR(50)
);

CREATE TABLE fact_sales (
    sale_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES dim_customer(customer_id),
    seller_id INTEGER REFERENCES dim_seller(seller_id),
    product_id INTEGER REFERENCES dim_product(product_id),
    supplier_id INTEGER REFERENCES dim_supplier(supplier_id),
    store_id INTEGER REFERENCES dim_store(store_id),
    sale_date VARCHAR(50),
    quantity INTEGER,
    total_price NUMERIC
);
