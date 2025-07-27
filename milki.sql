-- ==========================================
-- 1. USER & ROLE MANAGEMENT
-- ==========================================
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100),
    password_hash TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    role_id INT,
    UNIQUE(user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- ==========================================
-- 2. FACTORIES & STORES
-- ==========================================
CREATE TABLE factories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE stores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    factory_id INT,
    name VARCHAR(100) NOT NULL,
    type ENUM('raw_material', 'finished_goods', 'general') NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (factory_id, name),
    FOREIGN KEY (factory_id) REFERENCES factories(id) ON DELETE CASCADE
);

-- ==========================================
-- 3. PRODUCT CATALOG
-- ==========================================
CREATE TABLE product_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(30) UNIQUE NOT NULL,
    category_id INT,
    unit VARCHAR(20) NOT NULL,
    type ENUM('raw', 'semi_finished', 'finished') NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES product_categories(id)
);

-- ==========================================
-- 4. STOCK MANAGEMENT
-- ==========================================
CREATE TABLE stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT,
    product_id INT,
    quantity DECIMAL(15, 3) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES stores(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ==========================================
-- 5. TRANSACTIONS (IN/OUT/TRANSFER)
-- ==========================================
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_type ENUM('incoming', 'outgoing', 'transfer') NOT NULL,
    store_id INT,
    product_id INT,
    quantity DECIMAL(15, 3) CHECK (quantity >= 0),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source_or_destination TEXT,
    reference TEXT,
    created_by INT,
    remarks TEXT,
    FOREIGN KEY (store_id) REFERENCES stores(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE store_transfers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    from_store_id INT,
    to_store_id INT,
    product_id INT,
    quantity DECIMAL(15, 3) CHECK (quantity > 0),
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    initiated_by INT,
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_store_id) REFERENCES stores(id),
    FOREIGN KEY (to_store_id) REFERENCES stores(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (initiated_by) REFERENCES users(id)
);

-- ==========================================
-- 6. PRODUCT PROCESSING
-- ==========================================
CREATE TABLE processing (
    id INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT,
    output_product_id INT,
    total_output_quantity DECIMAL(15, 3),
    processing_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (store_id) REFERENCES stores(id),
    FOREIGN KEY (output_product_id) REFERENCES products(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE processing_inputs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    processing_id INT,
    input_product_id INT,
    quantity_used DECIMAL(15, 3),
    FOREIGN KEY (processing_id) REFERENCES processing(id) ON DELETE CASCADE,
    FOREIGN KEY (input_product_id) REFERENCES products(id)
);

-- ==========================================
-- 7. SUPPLIER PURCHASE ORDERS
-- ==========================================
CREATE TABLE suppliers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact TEXT
);

CREATE TABLE purchase_orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'approved', 'fulfilled', 'cancelled') DEFAULT 'pending',
    expected_delivery DATE,
    remarks TEXT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

CREATE TABLE purchase_order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    purchase_order_id INT,
    product_id INT,
    quantity DECIMAL(15, 3),
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (purchase_order_id) REFERENCES purchase_orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ==========================================
-- 8. CUSTOMER SALES ORDERS
-- ==========================================
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact TEXT
);

CREATE TABLE sales_orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'approved', 'fulfilled', 'cancelled') DEFAULT 'pending',
    delivery_date DATE,
    remarks TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE sales_order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sales_order_id INT,
    product_id INT,
    quantity DECIMAL(15, 3),
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (sales_order_id) REFERENCES sales_orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ==========================================
-- 9. PAYMENTS
-- ==========================================
CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    payment_type ENUM('incoming', 'outgoing') NOT NULL,
    ref_order_id INT,
    ref_order_type VARCHAR(20), -- 'purchase' or 'sales'
    amount DECIMAL(15, 2),
    paid_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('unpaid', 'partial', 'paid') DEFAULT 'unpaid',
    paid_by TEXT,
    remarks TEXT
);

-- ==========================================
-- 10. AUDIT LOGS
-- ==========================================
CREATE TABLE transaction_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    action_type ENUM('CREATE', 'UPDATE', 'DELETE', 'PROCESS') NOT NULL,
    table_name VARCHAR(50),
    record_id INT,
    performed_by INT,
    action_details TEXT,
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (performed_by) REFERENCES users(id)
);
