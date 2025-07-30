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


--- ==============================================
--- ============================================
-- ==========================================
-- 1. Inventory per Store
-- =================================================
CREATE VIEW view_inventory_per_store AS
SELECT 
    s.name AS store_name,
    p.name AS product_name,
    p.code,
    stk.quantity,
    stk.last_updated
FROM stock stk
JOIN stores s ON stk.store_id = s.id
JOIN products p ON stk.product_id = p.id;

-- ==========================================
-- 2. Total Stock per Product
-- ==========================================
CREATE VIEW view_total_stock_per_product AS
SELECT 
    p.name AS product_name,
    p.code,
    SUM(stk.quantity) AS total_quantity
FROM stock stk
JOIN products p ON stk.product_id = p.id
GROUP BY stk.product_id;

-- ==========================================
-- 3. Sales Summary by Customer
-- ==========================================
CREATE VIEW view_sales_summary_by_customer AS
SELECT 
    c.name AS customer_name,
    COUNT(so.id) AS total_orders,
    SUM(soi.quantity * soi.unit_price) AS total_sales_amount
FROM sales_orders so
JOIN customers c ON so.customer_id = c.id
JOIN sales_order_items soi ON soi.sales_order_id = so.id
GROUP BY c.id;

-- ==========================================
-- 4. Purchase Summary by Supplier
-- ==========================================
CREATE VIEW view_purchase_summary_by_supplier AS
SELECT 
    s.name AS supplier_name,
    COUNT(po.id) AS total_orders,
    SUM(poi.quantity * poi.unit_price) AS total_purchase_amount
FROM purchase_orders po
JOIN suppliers s ON po.supplier_id = s.id
JOIN purchase_order_items poi ON poi.purchase_order_id = po.id
GROUP BY s.id;

-- ==========================================
-- 5. Payments Summary
-- ==========================================
CREATE VIEW view_payments_summary AS
SELECT 
    payment_type,
    status,
    COUNT(id) AS total_transactions,
    SUM(amount) AS total_amount
FROM payments
GROUP BY payment_type, status;

-- ==========================================
-- 6. Store Transfers Summary
-- ==========================================
CREATE VIEW view_store_transfers_summary AS
SELECT 
    f.name AS from_store,
    t.name AS to_store,
    p.name AS product_name,
    SUM(st.quantity) AS total_transferred
FROM store_transfers st
JOIN stores f ON st.from_store_id = f.id
JOIN stores t ON st.to_store_id = t.id
JOIN products p ON st.product_id = p.id
GROUP BY f.name, t.name, p.name;

-- ==========================================
-- 7. Processing Output Summary
-- ==========================================
CREATE VIEW view_processing_output_summary AS
SELECT 
    p.name AS output_product,
    pr.total_output_quantity,
    pr.processing_date,
    s.name AS store,
    u.username AS created_by
FROM processing pr
JOIN products p ON pr.output_product_id = p.id
JOIN stores s ON pr.store_id = s.id
JOIN users u ON pr.created_by = u.id;

-- ==========================================
-- 8. Processing Input Summary
-- ==========================================
CREATE VIEW view_processing_input_summary AS
SELECT 
    pi.processing_id,
    p.name AS input_product,
    pi.quantity_used
FROM processing_inputs pi
JOIN products p ON pi.input_product_id = p.id;

-- ==========================================
-- 9. Stock Value Summary
-- ==========================================
CREATE VIEW view_stock_value_summary AS
WITH avg_price AS (
  SELECT 
    product_id, 
    AVG(unit_price) AS avg_unit_price
  FROM purchase_order_items
  GROUP BY product_id
)
SELECT 
    p.name AS product_name,
    stk.quantity,
    ap.avg_unit_price,
    stk.quantity * ap.avg_unit_price AS stock_value
FROM stock stk
JOIN products p ON stk.product_id = p.id
JOIN avg_price ap ON stk.product_id = ap.product_id;

-- ==========================================
-- 10. User Activity Log Summary
-- ==========================================
CREATE VIEW view_user_activity_log_summary AS
SELECT 
    u.username,
    tl.table_name,
    tl.action_type,
    COUNT(*) AS total_actions
FROM transaction_logs tl
JOIN users u ON tl.performed_by = u.id
GROUP BY u.username, tl.table_name, tl.action_type;

-- ==========================================
-- 11. Monthly Sales Trend
-- ==========================================
CREATE VIEW view_monthly_sales_trend AS
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(soi.quantity * soi.unit_price) AS total_sales
FROM sales_orders so
JOIN sales_order_items soi ON soi.sales_order_id = so.id
GROUP BY month;

-- ==========================================
-- 12. Monthly Purchases Trend
-- ==========================================
CREATE VIEW view_monthly_purchases_trend AS
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(poi.quantity * poi.unit_price) AS total_purchases
FROM purchase_orders po
JOIN purchase_order_items poi ON poi.purchase_order_id = po.id
GROUP BY month;
