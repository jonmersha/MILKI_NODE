### ✅ 1. `factories`

## \_\_\_/get/data/0

```json
{
  "Data": [
    {
      "name": "Addis Flour Factory",
      "location": "Addis Ababa",
      "manager_id": 1
    }
  ]
}
```

---

### ✅ 2. `stores`

## \_\_\_/get/data/1

```json
{
  "Data": [
    {
      "factory_id": 1,
      "name": "Main Warehouse",
      "location": "Kality"
    }
  ]
}
```

---

### ✅ 3. `products`

## \_\_\_/get/data/2

```json
{
  "Data": [
    {
      "code": "FLR-001",
      "name": "White Teff Flour",
      "type": "finished",
      "unit": "kg"
    }
  ]
}
```

---

### ✅ 4. `raw_materials`

## \_\_\_/get/data/3

```json
{
  "Data": [
    {
      "code": "RM-001",
      "name": "White Teff",
      "supplier_id": 1,
      "unit": "kg",
      "unit_price": 25.0
    }
  ]
}
```

---

### ✅ 5. `suppliers`

## \_\_\_/get/data/4

```json
{
  "Data": [
    {
      "name": "Ethiopian Agro Suppliers",
      "contact_person": "Hirut Lemma",
      "phone": "+251911123456",
      "email": "hirut@agrosuppliers.et",
      "address": "Debre Zeit"
    }
  ]
}
```

---

### ✅ 6. `employees`

## \_\_\_/get/data/5

```json
{
  "Data": [
    {
      "first_name": "Tadesse",
      "last_name": "Gebre",
      "role": "store_keeper",
      "phone": "+251911222333",
      "email": "tadesse@addisfactory.et",
      "factory_id": 1
    }
  ]
}
```

---

### ✅ 7. `incoming_products`

## \_\_\_/get/data/6

```json
{
  "Data": [
    {
      "product_id": 1,
      "store_id": 1,
      "quantity": 1000,
      "received_date": "2025-07-25T09:00:00",
      "received_by": 1
    }
  ]
}
```

---

### ✅ 8. `outgoing_products`

## \_\_\_/get/data/7

```json
{
  "Data": [
    {
      "product_id": 1,
      "store_id": 1,
      "quantity": 200,
      "dispatched_date": "2025-07-26T10:00:00",
      "dispatched_by": 1,
      "order_id": 1
    }
  ]
}
```

---

### ✅ 9. `orders`

## \_\_\_/get/data/8

```json
{
  "Data": [
    {
      "order_number": "ORD-0000",
      "customer_name": "Amanuel Bakery",
      "product_id": 1,
      "quantity": 200,
      "price_per_unit": 38.0,
      "order_date": "2025-07-24",
      "delivery_date": "2025-07-27",
      "status": "confirmed"
    }
  ]
}
```

---

### ✅ 10. `payments`

## \_\_\_/get/data/9

```json
{
  "Data": [
    {
      "order_id": 1,
      "payment_date": "2025-07-26",
      "amount_paid": 7600.0,
      "payment_method": "bank_transfer",
      "received_by": 1
    }
  ]
}
```

---

### ✅ 11. `transactions`

## \_\_\_/get/data/10

```json
{
  "Data": [
    {
      "type": "incoming",
      "product_id": 1,
      "store_id": 1,
      "quantity": 1000,
      "transaction_date": "2025-07-25T09:00:00",
      "created_by": 1
    }
  ]
}
```

---

### ✅ 12. `product_batches`

## \_\_\_/get/data/11

```json
{
  "Data": [
    {
      "product_id": 1,
      "batch_number": "BATCH-0001",
      "manufacture_date": "2025-07-23",
      "expiry_date": "2026-01-23",
      "quantity": 1000
    }
  ]
}
```

---

### ✅ 13. `inventory_logs`

## \_\_\_/get/data/12

```json
{
  "Data": [
    {
      "product_id": 1,
      "store_id": 1,
      "action": "add",
      "quantity": 1000,
      "log_date": "2025-07-25",
      "performed_by": 1
    }
  ]
}
```

---

### ✅ 14. `product_recipes`

## \_\_\_/get/data/13

```json
{
  "Data": [
    {
      "product_id": 1,
      "raw_material_id": 1,
      "quantity_required": 1.5
    }
  ]
}
```

---

### ✅ 15. `product_quality_checks`

## \_\_\_/get/data/14

```json
{
  "Data": [
    {
      "product_id": 1,
      "checked_by": 1,
      "check_date": "2025-07-25",
      "status": "passed",
      "remarks": "Quality confirmed"
    }
  ]
}
```

---

### ✅ 16. `store_transfers`

## \_\_\_/get/data/15

```json
{
  "Data": [
    {
      "product_id": 1,
      "from_store_id": 1,
      "to_store_id": 1,
      "quantity": 100,
      "transfer_date": "2025-07-25",
      "approved_by": 1
    }
  ]
}
```

---

### ✅ 17. `customer_feedback`

## \_\_\_/get/data/16

```json
{
  "Data": [
    {
      "order_id": 1,
      "customer_name": "Amanuel Bakery",
      "feedback_date": "2025-07-28",
      "rating": 5,
      "comments": "Excellent flour quality"
    }
  ]
}
```

---

### ✅ 18. `product_returns`

## \_\_\_/get/data/17

```json
{
  "Data": [
    {
      "order_id": 1,
      "product_id": 1,
      "quantity": 5,
      "return_date": "2025-07-29",
      "reason": "Damaged during delivery"
    }
  ]
}
```

---

### ✅ 19. `system_users`

## \_\_\_/get/data/18

```json
{
  "Data": [
    {
      "username": "admin",
      "password_hash": "hashed_password_123",
      "role": "admin",
      "email": "admin@factory.com"
    }
  ]
}
```

---

### ✅ 20. `audit_logs`

## \_\_\_/get/data/19

```json
{
  "Data": [
    {
      "user_id": 1,
      "action": "insert",
      "table_name": "products",
      "record_id": 1,
      "action_time": "2025-07-27T12:00:00",
      "remarks": "Initial product entry"
    }
  ]
}
```

---

If you want:

- ✅ SQL insert scripts for each
- ✅ JSON file download
- ✅ Seed logic for Node.js or Django
- ✅ MongoDB or PostgreSQL versions

Just let me know!
