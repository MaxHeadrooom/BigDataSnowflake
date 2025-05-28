CREATE TABLE dim_date (
    date_id SERIAL PRIMARY KEY,
    full_date DATE NOT NULL,
    day INTEGER GENERATED ALWAYS AS (EXTRACT(DAY FROM full_date)::INTEGER) STORED,
    month INTEGER GENERATED ALWAYS AS (EXTRACT(MONTH FROM full_date)::INTEGER) STORED,
    year INTEGER GENERATED ALWAYS AS (EXTRACT(YEAR FROM full_date)::INTEGER) STORED,
    day_of_week INTEGER GENERATED ALWAYS AS (EXTRACT(DOW FROM full_date)::INTEGER) STORED,
    quarter INTEGER GENERATED ALWAYS AS (EXTRACT(QUARTER FROM full_date)::INTEGER) STORED
);

CREATE TABLE dim_person_name (
    name_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

CREATE TABLE dim_country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE dim_region (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL,
    country_id INTEGER NOT NULL REFERENCES dim_country(country_id)
);

CREATE TABLE dim_postal_code (
    postal_code VARCHAR(20) PRIMARY KEY,
    country_id INTEGER NOT NULL REFERENCES dim_country(country_id),
    region_id INTEGER REFERENCES dim_region(region_id)
);

CREATE TABLE dim_city (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(50) NOT NULL,
    state VARCHAR(50),
    country_id INTEGER REFERENCES dim_country(country_id)
);
в
CREATE TABLE dim_category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE dim_brand (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE dim_brand_country (
    brand_id INTEGER PRIMARY KEY REFERENCES dim_brand(brand_id),
    country_id INTEGER NOT NULL REFERENCES dim_country(country_id)
);

CREATE TABLE dim_color (
    color_id SERIAL PRIMARY KEY,
    color_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE dim_size (
    size_id SERIAL PRIMARY KEY,
    size_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE dim_material (
    material_id SERIAL PRIMARY KEY,
    material_name VARCHAR(50) UNIQUE NOT NULL
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
    pet_type_id INTEGER NOT NULL REFERENCES dim_pet_type(pet_type_id),
    pet_category_id INTEGER NOT NULL REFERENCES dim_pet_category(pet_category_id)
);

CREATE TABLE dim_customer (
    customer_id INTEGER PRIMARY KEY,
    name_id INTEGER REFERENCES dim_person_name(name_id),
    age INTEGER,
    email VARCHAR(100),
    country_id INTEGER REFERENCES dim_country(country_id),
    postal_code VARCHAR(20) REFERENCES dim_postal_code(postal_code)
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
    name_id INTEGER REFERENCES dim_person_name(name_id),
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
    city_id INTEGER REFERENCES dim_city(city_id)
);

CREATE TABLE dim_store (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    city_id INTEGER REFERENCES dim_city(city_id),
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
    color_id INTEGER REFERENCES dim_color(color_id),
    size_id INTEGER REFERENCES dim_size(size_id),
    brand_id INTEGER REFERENCES dim_brand(brand_id),
    material_id INTEGER REFERENCES dim_material(material_id),
    rating NUMERIC
);

CREATE TABLE dim_product_dates (
    product_id INTEGER PRIMARY KEY REFERENCES dim_product(product_id),
    release_date_id INTEGER REFERENCES dim_date(date_id),
    expiry_date_id INTEGER REFERENCES dim_date(date_id)
);

CREATE TABLE dim_product_texts (
    product_id INTEGER PRIMARY KEY REFERENCES dim_product(product_id),
    description TEXT,
    reviews TEXT
);

CREATE TABLE fact_sales (
    sale_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES dim_customer(customer_id),
    seller_id INTEGER REFERENCES dim_seller(seller_id),
    product_id INTEGER REFERENCES dim_product(product_id),
    supplier_id INTEGER REFERENCES dim_supplier(supplier_id),
    store_id INTEGER REFERENCES dim_store(store_id),
    sale_date_id INTEGER REFERENCES dim_date(date_id),
    quantity INTEGER,
    total_price NUMERIC
);
