# ⚙️ Ejemplos de Triggers en MySQL

A continuación se presentan **dos ejemplos prácticos de triggers (disparadores)** en **MySQL**, que se ejecutan automáticamente cuando se insertan registros en las tablas `orders` y `products`.

---

## 🧩 Ejemplo 1 — Trigger sobre la tabla `orders`

### 🎯 Objetivo:
Registrar automáticamente en una tabla de auditoría (`order_log`) cada vez que se inserte un nuevo pedido en `orders`.

---

### 1️⃣ Crear la tabla principal y la tabla de log

```sql
CREATE TABLE orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    OrderDate DATE,
    ShipperID INT
);

CREATE TABLE order_log (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ActionType VARCHAR(20),
    ActionDate DATETIME
);
```

---

### 2️⃣ Crear el trigger `after_order_insert`

```sql
DELIMITER $$

CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO order_log (OrderID, ActionType, ActionDate)
    VALUES (NEW.OrderID, 'INSERT', NOW());
END$$

DELIMITER ;
```

---

### 3️⃣ Insertar un registro en `orders`

```sql
INSERT INTO orders (OrderID, CustomerID, EmployeeID, OrderDate, ShipperID)
VALUES (20001, 90, 5, '2025-10-23', 3);
```

---

### 4️⃣ Verificar el log

```sql
SELECT * FROM order_log;
```

**Resultado esperado:**

| LogID | OrderID | ActionType | ActionDate           |
|--------|----------|-------------|----------------------|
| 1 | 20001 | INSERT | 2025-10-23 10:42:11 |

📘 El trigger insertó automáticamente un registro en `order_log` con la acción **INSERT**.

---

## 🧩 Ejemplo 2 — Trigger sobre la tabla `products`

### 🎯 Objetivo:
Evitar que se inserten productos con un precio menor o igual a cero.

---

### 1️⃣ Crear la tabla `products`

```sql
CREATE TABLE products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    Unit VARCHAR(50),
    Price DECIMAL(10,2)
);
```

---

### 2️⃣ Crear el trigger `before_product_insert`

```sql
DELIMITER $$

CREATE TRIGGER before_product_insert
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF NEW.Price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El precio del producto debe ser mayor que cero.';
    END IF;
END$$

DELIMITER ;
```

---

### 3️⃣ Insertar productos

#### ✅ Inserción válida:

```sql
INSERT INTO products (ProductID, ProductName, SupplierID, CategoryID, Unit, Price)
VALUES (501, 'Queso Manchego', 12, 4, '10 - 500 g pkgs', 38.00);
```

#### ❌ Inserción inválida:

```sql
INSERT INTO products (ProductID, ProductName, SupplierID, CategoryID, Unit, Price)
VALUES (502, 'Queso Azul', 12, 4, '5 kg pkg', 0);
```

> ❗ **Error 1644 (45000): Error: El precio del producto debe ser mayor que cero.**

---

## 🧭 Conclusión

| Trigger | Evento | Tipo | Efecto |
|----------|---------|-------|--------|
| `after_order_insert` | `AFTER INSERT ON orders` | Acción automática | Inserta registro en `order_log`. |
| `before_product_insert` | `BEFORE INSERT ON products` | Validación | Impide precios no válidos. |

Estos ejemplos muestran cómo los **triggers en MySQL** permiten automatizar auditorías y mantener la integridad de los datos.
