-- ==========================================
-- 0. ENUM DEFINITIONS
-- ==========================================
CREATE TYPE store_type AS ENUM ('raw_material', 'finished_goods', 'general');
CREATE TYPE product_type AS ENUM ('raw', 'semi_finished', 'finished');
CREATE TYPE transaction_type AS ENUM ('incoming', 'outgoing', 'transfer');
CREATE TYPE order_status AS ENUM ('pending', 'approved', 'fulfilled', 'cancelled');
CREATE TYPE payment_type AS ENUM ('incoming', 'outgoing');
CREATE TYPE payment_status AS ENUM ('unpaid', 'partial', 'paid');
CREATE TYPE action_type AS ENUM ('CREATE', 'UPDATE', 'DELETE', 'PROCESS');

-- ==========================================
-- 1. USER & ROLE MANAGEMENT
-- ==========================================
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100),
    password_hash TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_roles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    role_id INTEGER REFERENCES roles(id),
    UNIQUE(user_id, role_id)
);

-- ==========================================
-- 2. FACTORIES & STORES
-- ==========================================
CREATE TABLE factories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE stores (
    id SERIAL PRIMARY KEY,
    factory_id INTEGER REFERENCES factories(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    type store_type NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (factory_id, name)
);

-- ==========================================
-- 3. PRODUCT CATALOG
-- ==========================================
CREATE TABLE product_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(30) UNIQUE NOT NULL,
    category_id INTEGER REFERENCES product_categories(id),
    unit VARCHAR(20) NOT NULL, -- e.g. kg, quintal
    type product_type NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 4. STOCK MANAGEMENT
-- ==========================================
CREATE TABLE stock (
    id SERIAL PRIMARY KEY,
    store_id INTEGER REFERENCES stores(id),
    product_id INTEGER REFERENCES products(id),
    quantity NUMERIC(15, 3) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (store_id, product_id)
);

-- ==========================================
-- 5. TRANSACTIONS (IN/OUT/TRANSFER)
-- ==========================================
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    transaction_type transaction_type NOT NULL,
    store_id INTEGER REFERENCES stores(id),
    product_id INTEGER REFERENCES products(id),
    quantity NUMERIC(15, 3) CHECK (quantity >= 0),
    transaction_date DATE DEFAULT CURRENT_DATE,
    source_or_destination TEXT,
    reference TEXT,
    created_by INTEGER REFERENCES users(id),
    remarks TEXT
);

-- Optional: for internal transfers
CREATE TABLE store_transfers (
    id SERIAL PRIMARY KEY,
    from_store_id INTEGER REFERENCES stores(id),
    to_store_id INTEGER REFERENCES stores(id),
    product_id INTEGER REFERENCES products(id),
    quantity NUMERIC(15, 3) CHECK (quantity > 0),
    transfer_date DATE DEFAULT CURRENT_DATE,
    initiated_by INTEGER REFERENCES users(id),
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 6. PRODUCT PROCESSING (e.g., mix wheat + corn)
-- ==========================================
CREATE TABLE processing (
    id SERIAL PRIMARY KEY,
    store_id INTEGER REFERENCES stores(id),
    output_product_id INTEGER REFERENCES products(id),
    total_output_quantity NUMERIC(15, 3),
    processing_date DATE DEFAULT CURRENT_DATE,
    created_by INTEGER REFERENCES users(id),
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE processing_inputs (
    id SERIAL PRIMARY KEY,
    processing_id INTEGER REFERENCES processing(id) ON DELETE CASCADE,
    input_product_id INTEGER REFERENCES products(id),
    quantity_used NUMERIC(15, 3)
);

-- ==========================================
-- 7. SUPPLIER PURCHASE ORDERS
-- ==========================================
CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact TEXT
);

CREATE TABLE purchase_orders (
    id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(id),
    order_date DATE DEFAULT CURRENT_DATE,
    status order_status DEFAULT 'pending',
    expected_delivery DATE,
    remarks TEXT
);

CREATE TABLE purchase_order_items (
    id SERIAL PRIMARY KEY,
    purchase_order_id INTEGER REFERENCES purchase_orders(id),
    product_id INTEGER REFERENCES products(id),
    quantity NUMERIC(15, 3),
    unit_price NUMERIC(10, 2)
);

-- ==========================================
-- 8. CUSTOMER SALES ORDERS
-- ==========================================
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact TEXT
);

CREATE TABLE sales_orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    order_date DATE DEFAULT CURRENT_DATE,
    status order_status DEFAULT 'pending',
    delivery_date DATE,
    remarks TEXT
);

CREATE TABLE sales_order_items (
    id SERIAL PRIMARY KEY,
    sales_order_id INTEGER REFERENCES sales_orders(id),
    product_id INTEGER REFERENCES products(id),
    quantity NUMERIC(15, 3),
    unit_price NUMERIC(10, 2)
);

-- ==========================================
-- 9. PAYMENTS (CUSTOMERS & SUPPLIERS)
-- ==========================================
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    payment_type payment_type NOT NULL, -- incoming = from customer, outgoing = to supplier
    ref_order_id INTEGER,
    ref_order_type VARCHAR(20), -- 'purchase' or 'sales'
    amount NUMERIC(15, 2),
    paid_on DATE DEFAULT CURRENT_DATE,
    status payment_status DEFAULT 'unpaid',
    paid_by TEXT,
    remarks TEXT
);

-- ==========================================
-- 10. AUDIT LOGS
-- ==========================================
CREATE TABLE transaction_logs (
    id SERIAL PRIMARY KEY,
    action_type action_type NOT NULL,
    table_name VARCHAR(50),
    record_id INTEGER,
    performed_by INTEGER REFERENCES users(id),
    action_details TEXT,
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
