let table = [
  // 0. USER & ROLE MANAGEMENT
  "roles", // 0
  "users", // 1
  "user_roles", // 2

  // 3. FACTORIES & STORES
  "factories", // 3
  "stores", // 4

  // 5. PRODUCT CATALOG
  "product_categories", // 5
  "products", // 6

  // 7. STOCK MANAGEMENT
  "stock", // 7

  // 8. TRANSACTIONS (IN/OUT/TRANSFER)
  "transactions", // 8
  "store_transfers", // 9

  // 10. PRODUCT PROCESSING
  "processing", // 10
  "processing_inputs", // 11

  // 12. SUPPLIER PURCHASE ORDERS
  "suppliers", // 12
  "purchase_orders", // 13
  "purchase_order_items", // 14

  // 15. CUSTOMER SALES ORDERS
  "customers", // 15
  "sales_orders", // 16
  "sales_order_items", // 17

  // 18. PAYMENTS
  "payments", // 18

  // 19. AUDIT LOGS
  "transaction_logs", // 19

  "view_inventory_per_store", // 20
  "view_total_stock_per_product", // 21
  "view_stock_value_summary", // 22
  "view_sales_summary_by_customer", // 23
  "view_monthly_sales_trend", // 24
  "view_purchase_summary_by_supplier", // 25
  "view_monthly_purchases_trend", // 26
  "view_payments_summary", // 27
  "view_store_transfers_summary", // 28
  "view_processing_output_summary", // 29
  "view_processing_input_summary", // 30
  "view_user_activity_log_summary", // 31
];
module.exports = table;
