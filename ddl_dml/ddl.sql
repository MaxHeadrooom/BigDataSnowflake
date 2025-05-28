CREATE TABLE dim_category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE dim_brand (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE dim_country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE dim_postal_code (
    postal_code VARCHAR(20) PRIMARY KEY,
    country_id INTEGER REFERENCES dim_country(country_id)
);

CREATE TABLE dim_customer (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INTEGER,
    email VARCHAR(100),
    country_id INTEGER REFERENCES dim_country(country_id),
    postal_code VARCHAR(20) REFERENCES dim_postal_code(postal_code)
);

CREATE TABLE dim_pet_type (
    pet_type_id SERIAL PRIMARY KEY,
    pet_type_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE dim_pet_category (
    pet_category_id SERIAL PRIMARY KEY,
    pet_category_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE dim_pet_breed (
    pet_breed_id SERIAL PRIMARY KEY,
    pet_breed_name VARCHAR(50) UNIQUE NOT NULL,
    pet_type_id INTEGER REFERENCES dim_pet_type(pet_type_id)
);

CREATE TABLE dim_customer_pet (
    customer_id INTEGER REFERENCES dim_customer(customer_id),
    pet_name VARCHAR(50),
    pet_type_id INTEGER REFERENCES dim_pet_type(pet_type_id),
    pet_breed_id INTEGER REFERENCES dim_pet_breed(pet_breed_id),
    pet_category_id INTEGER REFERENCES dim_pet_category(pet_category_id)
);

CREATE TABLE dim_seller (
    seller_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    country_id INTEGER REFERENCES dim_country(country_id),
    postal_code VARCHAR(20) REFERENCES dim_postal_code(postal_code)
);

CREATE TABLE dim_supplier (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    contact VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(50),
    address VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE dim_store (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    phone VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE dim_product (
    product_id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    category_id INTEGER REFERENCES dim_category(category_id),
    price NUMERIC,
    quantity INTEGER,
    weight NUMERIC,
    brand_id INTEGER REFERENCES dim_brand(brand_id),
    description TEXT,
    rating NUMERIC,
    reviews TEXT,
    release_date VARCHAR(50),
    expiry_date VARCHAR(50)
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
