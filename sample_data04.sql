USE mypos;

INSERT INTO taxes (name, rate, is_liquor_specific) 
VALUES ('Standard Tax', 8.875, FALSE);

INSERT INTO vendors (name, contact_name, phone, email, address) 
VALUES ('Global Beverages Inc.', 'John Doe', '555-0199', 'john@globalbev.com', '123 Warehouse St');

INSERT INTO products (sku, barcode, name, category, subcategory, size, is_age_restricted, cost_price, retail_price, bottle_deposit, vendor_id, tax_id) 
VALUES ('SKU-WINE-001', '123456789012', 'Cabernet Sauvignon', 'Wine', 'Red Wine', '750ml', TRUE, 10.00, 19.99, 0.05, 1, 1);

INSERT INTO inventory (product_id, quantity, reorder_level, reorder_quantity) 
VALUES (1, 50, 5, 12);

INSERT INTO customers (name, phone, email) 
VALUES ('Jane Smith', '555-0143', 'jane@example.com');

INSERT INTO employees (name, username, password_hash, role) 
VALUES ('Admin User', 'admin', 'hashed_password_here', 'admin');
