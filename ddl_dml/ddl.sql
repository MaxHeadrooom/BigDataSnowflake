CREATE TABLE dim_date (
    date_key   INTEGER     PRIMARY KEY,      -- YYYYMMDD
    full_date  DATE        NOT NULL,
    year       INTEGER     NOT NULL,
    quarter    INTEGER     NOT NULL,
    month      INTEGER     NOT NULL,
    day        INTEGER     NOT NULL,
    weekday    TEXT        NOT NULL
);

CREATE TABLE dim_customer (
    customer_key     SERIAL   PRIMARY KEY,
    customer_src_id  BIGINT   UNIQUE NOT NULL,
    first_name       TEXT,
    last_name        TEXT,
    age              INTEGER,
    email            TEXT,
    country          TEXT,
    postal_code      TEXT,
    pet_type         TEXT,
    pet_name         TEXT,
    pet_breed        TEXT
);

CREATE TABLE dim_seller (
    seller_key      SERIAL   PRIMARY KEY,
    seller_src_id   BIGINT   UNIQUE NOT NULL,
    first_name      TEXT,
    last_name       TEXT,
    email           TEXT,
    country         TEXT,
    postal_code     TEXT
);
CREATE TABLE dim_supplier (
  supplier_key SERIAL PRIMARY KEY,
  name        TEXT   UNIQUE NOT NULL 
);

CREATE TABLE dim_store (
  store_key SERIAL PRIMARY KEY,
  name      TEXT   UNIQUE NOT NULL
);

CREATE TABLE dim_product (
    product_key      SERIAL   PRIMARY KEY,
    product_src_id   BIGINT   UNIQUE NOT NULL,
    name             TEXT,
    category         TEXT,
    price            NUMERIC(10,2),
    weight           DECIMAL(10,2),
    color            TEXT,
    size             TEXT,
    brand            TEXT,
    material         TEXT,
    description      TEXT,
    rating           DECIMAL(3,1),
    reviews          INTEGER,
    release_date     DATE,
    expiry_date      DATE
);

CREATE TABLE fact_sales (
    sale_key      BIGSERIAL   PRIMARY KEY,
    date_key      INTEGER     NOT NULL REFERENCES dim_date(date_key),
    customer_key  INTEGER     NOT NULL REFERENCES dim_customer(customer_key),
    seller_key    INTEGER     NOT NULL REFERENCES dim_seller(seller_key),
    supplier_key  INTEGER     REFERENCES dim_supplier(supplier_key),
    store_key     INTEGER     REFERENCES dim_store(store_key),
    product_key   INTEGER     NOT NULL REFERENCES dim_product(product_key),
    quantity      INTEGER     NOT NULL,
    unit_price    NUMERIC(10,2) NOT NULL,
    total_price   NUMERIC(12,2) NOT NULL
);
