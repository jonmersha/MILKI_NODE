-- 1. Company
CREATE TABLE Company (
    C_CODE INT AUTO_INCREMENT PRIMARY KEY,
    C_name VARCHAR(100),
    C_description TEXT,
    logo_url TEXT,
    comaney_status VARCHAR(20),
    created_at DATETIME,
    updated_at DATETIME
);

-- 2. Factory_Branches
CREATE TABLE Factory(
    F_CODE varchar(10) PRIMARY KEY,
    C_CODE INT,
    Factory_name VARCHAR(100),
    Factory_description TEXT,
    Factory_location TEXT,
    Factory_city VARCHAR(100),
    Factory_admin_region VARCHAR(100),
    Factory_unique_location VARCHAR(100),
    Factory_status VARCHAR(20),
    Factory_capacity INT,
    is_authorized BOOLEAN,
    authorization_time DATETIME,
    authorized_by INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (C_CODE) REFERENCES Company(C_CODE)
);

-- 3. Warehouses
CREATE TABLE Warehouses (
    W_CODE INT AUTO_INCREMENT PRIMARY KEY,
    C_CODE INT,
    F_CODE varchar(10),
    warehouse_capacity INT,
    warehouse_status VARCHAR(20),
    is_authorized BOOLEAN,
    authorization_time DATETIME,
    authorized_by INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (C_CODE) REFERENCES Company(C_CODE),
    FOREIGN KEY (F_CODE) REFERENCES Factory(F_CODE)
);

-- 4. Products
CREATE TABLE Products (
    P_CODE varchar(10) PRIMARY KEY,
    product_code VARCHAR(100) UNIQUE,
    product_name VARCHAR(100),
    product_description TEXT,
    product_type VARCHAR(100),
    product_unit VARCHAR(50),
    product_status VARCHAR(20),
    is_authorized BOOLEAN,
    authorization_time DATETIME,
    authorized_by INT,
    created_at DATETIME,
    updated_at DATETIME
);

-- 5. Inventory
CREATE TABLE Inventory (
    INV_CODE INT AUTO_INCREMENT PRIMARY KEY,
    P_CODE varchar(10),
    F_CODE varchar(10),
    W_CODE INT,
    p_quantity INT,
    old_price double,
    product_price VARCHAR(10),
    last_updated DATETIME,
    old_amount double,
    invertory_status VARCHAR(20),-- [stock, semi-processed,finlized]
    is_authorized BOOLEAN,
    authorization_time DATETIME,
    authorized_by INT,
    FOREIGN KEY (P_CODE) REFERENCES Products(P_CODE),
    FOREIGN KEY (F_CODE) REFERENCES Factory(F_CODE),
    FOREIGN KEY (W_CODE) REFERENCES Warehouses(W_CODE)
);

CREATE TABLE Inventory_Movement (
    IM_CODE INT AUTO_INCREMENT PRIMARY KEY,
    P_CODE varchar(10),
    IM_date DATETIME,
    price DECIMAL(12, 2),
    quantity INT,
    movement_type VARCHAR(20),
    source_factory_id varchar(10),
    source_store_id varchar(10),
    destination_factory_id varchar(10),
    destination_store_id varchar(10),
    remarks TEXT,
    IM_status VARCHAR(20),
    is_authorized BOOLEAN,
    authorization_time DATETIME,
    authorized_by INT,
    created_at DATETIME,
    FOREIGN KEY (P_CODE) REFERENCES Products(P_CODE)
);

-- 7. Purchase_Order
CREATE TABLE Purchase_Order (
    id INT AUTO_INCREMENT PRIMARY KEY,
    P_CODE varchar(10),
    ordering_factory_id varchar(10),
    destination_store_id varchar(10),
    order_date DATETIME,
    supplier_id INT,
    quantity_ordered INT,
    unit_price DECIMAL(12, 2),
    total_price DECIMAL(14, 2),
    p_status VARCHAR(20),
    payment_status VARCHAR(20),
    is_authorized BOOLEAN,
    authorization_time DATETIME,
    authorized_by INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (P_CODE) REFERENCES Products(P_CODE)
);

-- 8. Sales_Order
CREATE TABLE Sales_Order (
    id INT AUTO_INCREMENT PRIMARY KEY,
    P_CODE varchar(10),
    order_date DATETIME,
    quantity INT,
    source_factory_id varchar(10),
    source_store_id varchar(10),
    customer_id INT,
    unit_price DECIMAL(12, 2),
    total_price DECIMAL(14, 2),
    order_status VARCHAR(30),
    payment_status VARCHAR(20),
    is_authorized BOOLEAN,
    authorization_time DATETIME,
    authorized_by INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (P_CODE) REFERENCES Products(P_CODE)
);

-- 9. Suppliers
CREATE TABLE Suppliers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Supplier_name VARCHAR(100),
    Supplier_contact_person VARCHAR(100),
    Supplier_phone VARCHAR(20),
    Supplier_email VARCHAR(100),
    Supplier_address TEXT,
    C_CODE  INT,
    Supplier_status VARCHAR(20),
    is_authorized BOOLEAN,
    authorization_time DATETIME,
    authorized_by INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (C_CODE) REFERENCES Company(C_CODE)
);

-- 10. Customers
CREATE TABLE Customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    contact_person VARCHAR(100),
    customer_phone VARCHAR(20),
    customer_email VARCHAR(100),
    customer_address TEXT,
    C_CODE  INT,
    customer_status VARCHAR(20),
    is_authorized BOOLEAN,
    authorization_time DATETIME,
    authorized_by INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (C_CODE) REFERENCES Company(C_CODE)
);

-- 11. Roles
CREATE TABLE Roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(100),
    description TEXT,
    status VARCHAR(20),
    is_authorized BOOLEAN,
    authorization_time DATETIME,
    authorized_by INT,
    created_at DATETIME,
    updated_at DATETIME
);
-- 12. System_Users
CREATE TABLE System_Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE,
    password_hash TEXT,
    email VARCHAR(100),
    full_name VARCHAR(100),
    phone_number VARCHAR(20),
    role_id INT,
    status VARCHAR(20),
    last_login_time DATETIME,
    failed_login_attempts INT,
    is_authorized BOOLEAN,
    authorization_time DATETIME,
    authorized_by INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);



-- 13. Permissions
CREATE TABLE Permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    permission_code VARCHAR(100),
    permission_name VARCHAR(100),
    description TEXT,
    status VARCHAR(20),
    created_at DATETIME,
    updated_at DATETIME
);

-- 14. Role_Permissions
CREATE TABLE Role_Permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT,
    permission_id INT,
    can_create BOOLEAN,
    can_read BOOLEAN,
    can_update BOOLEAN,
    can_delete BOOLEAN,
    status VARCHAR(20),
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (role_id) REFERENCES Roles(id),
    FOREIGN KEY (permission_id) REFERENCES Permissions(id)
);

-- 15. User_Audit_Log
CREATE TABLE User_Audit_Log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(50),
    action_details TEXT,
    ip_address VARCHAR(45),
    device VARCHAR(100),
    timestamp DATETIME,
    FOREIGN KEY (user_id) REFERENCES System_Users(id)
);

-- 16. Segregation_Rules
CREATE TABLE Segregation_Rules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conflicting_roles TEXT,
    description TEXT,
    status VARCHAR(20),
    created_at DATETIME,
    updated_at DATETIME
);
