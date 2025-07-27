
-- 1. roles
INSERT INTO roles (name, description) VALUES
('admin', 'Administrator with full access'),
('manager', 'Factory or store manager'),
('operator', 'Handles processing and transactions');

-- 2. users
INSERT INTO users (username, email, password_hash) VALUES
('admin1', 'admin1@example.com', 'hashed_password1'),
('manager1', 'manager1@example.com', 'hashed_password2'),
('operator1', 'operator1@example.com', 'hashed_password3');

-- 3. user_roles
INSERT INTO user_roles (user_id, role_id) VALUES
(1, 1),
(2, 2),
(3, 3);

-- 4. factories
INSERT INTO factories (name, location) VALUES
('Central Factory', 'Addis Ababa'),
('North Factory', 'Gondar');

-- 5. stores
INSERT INTO stores (factory_id, name, type) VALUES
(1, 'Raw Store A', 'raw_material'),
(1, 'Finished Store A', 'finished_goods'),
(2, 'Raw Store B', 'raw_material');

-- 6. product_categories
INSERT INTO product_categories (name) VALUES
('Grains'),
('Flour');

-- 7. products
INSERT INTO products (name, code, category_id, unit, type, description) VALUES
('Wheat Grain', 'WG001', 1, 'kg', 'raw', 'Raw wheat grain'),
('Maize Grain', 'MG001', 1, 'kg', 'raw', 'Raw maize grain'),
('White Flour', 'WF001', 2, 'kg', 'finished', 'Refined white flour');

-- 8. stock
INSERT INTO stock (store_id, product_id, quantity) VALUES
(1, 1, 5000.000),
(1, 2, 3000.000),
(2, 3, 2500.000);

-- 9. transactions
INSERT INTO transactions (transaction_type, store_id, product_id, quantity, source_or_destination, reference, created_by, remarks) VALUES
('incoming', 1, 1, 1000.000, 'Supplier A', 'PO001', 2, 'Initial delivery'),
('outgoing', 2, 3, 500.000, 'Customer A', 'SO001', 2, 'Dispatched for order');

-- 10. store_transfers
INSERT INTO store_transfers (from_store_id, to_store_id, product_id, quantity, initiated_by, remarks) VALUES
(1, 2, 1, 200.000, 2, 'Transfer to finished store');

-- 11. processing
INSERT INTO processing (store_id, output_product_id, total_output_quantity, created_by, remarks) VALUES
(2, 3, 800.000, 3, 'Processed from wheat grain');

-- 12. processing_inputs
INSERT INTO processing_inputs (processing_id, input_product_id, quantity_used) VALUES
(1, 1, 1000.000);

-- 13. suppliers
INSERT INTO suppliers (name, contact) VALUES
('AgriSuppliers PLC', 'Abebe Tulu, 0911122233'),
('FarmTrade Ltd.', 'Selam Mekonnen, 0933445566');

-- 14. purchase_orders
INSERT INTO purchase_orders (supplier_id, status, expected_delivery, remarks) VALUES
(1, 'approved', '2025-08-01', 'Urgent stock refill');

-- 15. purchase_order_items
INSERT INTO purchase_order_items (purchase_order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2000.000, 4.50);

-- 16. customers
INSERT INTO customers (name, contact) VALUES
('Bakery House', 'Melat G, 0922113344'),
('Retail Foods', 'Dawit K, 0911002233');

-- 17. sales_orders
INSERT INTO sales_orders (customer_id, status, delivery_date, remarks) VALUES
(1, 'pending', '2025-08-03', 'Weekly order');

-- 18. sales_order_items
INSERT INTO sales_order_items (sales_order_id, product_id, quantity, unit_price) VALUES
(1, 3, 500.000, 12.00);

-- 19. payments
INSERT INTO payments (payment_type, ref_order_id, ref_order_type, amount, status, paid_by, remarks) VALUES
('incoming', 1, 'sales', 6000.00, 'partial', 'Bakery House', '50% advance');

-- 20. transaction_logs
INSERT INTO transaction_logs (action_type, table_name, record_id, performed_by, action_details) VALUES
('CREATE', 'products', 3, 1, 'Added new product White Flour'),
('UPDATE', 'stock', 1, 2, 'Adjusted quantity after receipt');
