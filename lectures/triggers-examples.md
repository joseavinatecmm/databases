# ⚙️ Ejemplos Prácticos de Triggers

A continuación se presentan **tres escenarios fundamentales** en el desarrollo de bases de datos sobre las tablas ya existentes en nuestro tutorial (`products`, `orders` y `order_log`)[cite: 1], agregando únicamente las estructuras nuevas necesarias (`Stock` y `order_details`) para probarlos de forma continua sin duplicar tablas.

---

### 🧩 Ejemplo 1 — Validación de Reglas de Negocio (`BEFORE INSERT`)

#### 🎯 Objetivo:
Evitar que se registren productos con un precio menor o igual a cero antes de guardarlos en la tabla `products` (ya creada en el esquema)[cite: 1].

#### 1️⃣ Crear el trigger `before_product_insert`

```sql
DROP TRIGGER IF EXISTS before_product_insert;
DELIMITER $$

CREATE TRIGGER before_product_insert
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF NEW.Price <= 0 OR NEW.Price IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El precio del producto debe ser mayor que cero';
    END IF;
END$$

DELIMITER ;
```

#### 2️⃣ Probar el trigger

* **✅ Inserción válida:**
  ```sql
  INSERT INTO products (ProductID, ProductName, SupplierID, CategoryID, Unit, Price)
  VALUES (501, 'Queso Manchego', 12, 4, '10 - 500 g pkgs', 38.00);
  ```

* **❌ Inserción inválida (detonará el error):**
  ```sql
  INSERT INTO products (ProductID, ProductName, SupplierID, CategoryID, Unit, Price)
  VALUES (502, 'Queso Azul', 12, 4, '5 kg pkg', 0);
  ```

> ❗ **Error 1644 (45000): Error: El precio del producto debe ser mayor que cero.**[cite: 1]

---

### 🧩 Ejemplo 2 — Auditoría y Registro en Bitácoras (`AFTER INSERT`)

#### 🎯 Objetivo:
Registrar automáticamente en la tabla de auditoría (`order_log`) cada vez que se inserte un nuevo pedido en `orders` (ambas tablas ya creadas previamente)[cite: 1].

#### 1️⃣ Crear el trigger `after_order_insert`

```sql
DROP TRIGGER IF EXISTS after_order_insert;
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

#### 2️⃣ Probar el trigger y verificar la bitácora

```sql
INSERT INTO orders (OrderID, CustomerID, EmployeeID, OrderDate, ShipperID)
VALUES (20001, 90, 5, '2025-10-23', 3);

SELECT * FROM order_log;
```

**Resultado esperado:**

| LogID | OrderID | ActionType | ActionDate |
| :--- | :--- | :--- | :--- |
| 1 | 20001 | INSERT | 2025-10-23 10:42:11 |

---

### 🧩 Ejemplo 3 — Actualización de Saldos e Inventarios (`AFTER INSERT`)

#### 🎯 Objetivo:
Descontar automáticamente las existencias (`Stock`) de un producto en `products` cada vez que se registre una venta en `order_details`.

#### 1️⃣ Agregar la columna `Stock` a `products` y crear la tabla nueva `order_details`

*(Como `order_details` y la columna `Stock` no se crearon en `mysql-tut-3.md`[cite: 1], las incorporamos aquí para vincularlas con `orders` y `products`[cite: 1]):*

```sql
-- 1. Agregamos el control de existencias a la tabla existente 'products'
ALTER TABLE products ADD COLUMN Stock INT NOT NULL DEFAULT 0;

-- Asignamos 50 unidades iniciales al producto 501 (Queso Manchego)
UPDATE products SET Stock = 50 WHERE ProductID = 501;

-- 2. Creamos la tabla nueva 'order_details'
CREATE TABLE order_details (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);
```

#### 2️⃣ Crear el trigger `after_order_detail_insert`

```sql
DROP TRIGGER IF EXISTS after_order_detail_insert;
DELIMITER $$

CREATE TRIGGER after_order_detail_insert
AFTER INSERT ON order_details
FOR EACH ROW
BEGIN
    UPDATE products
    SET Stock = Stock - NEW.Quantity
    WHERE ProductID = NEW.ProductID;
END$$

DELIMITER ;
```

#### 3️⃣ Probar el trigger y verificar el nuevo saldo

```sql
-- Se venden 8 unidades del producto 501 dentro de la orden 20001
INSERT INTO order_details (OrderDetailID, OrderID, ProductID, Quantity)
VALUES (1, 20001, 501, 8);

-- Verificamos que el inventario bajó automáticamente de 50 a 42
SELECT ProductID, ProductName, Stock
FROM products
WHERE ProductID = 501;
```

**Resultado esperado:**

| ProductID | ProductName | Stock |
| :--- | :--- | :--- |
| 501 | Queso Manchego | 42 |

---

### 🚦 Comprensión de Errores en MySQL: Nativo vs. Estándar

Cuando ocurre una excepción o falla una operación en MySQL, el gestor devuelve una respuesta dual que combina dos niveles de identificación: los **errores nativos** (códigos numéricos propios e internos del motor MySQL) y los **códigos `SQLSTATE`** (el estándar internacional ANSI/ISO SQL compartido por la mayoría de los gestores relacionales para garantizar portabilidad entre sistemas).

Por ejemplo, ante una excepción como `Error 1644 (45000)`, el primer número (`1644`) identifica el fallo específico dentro de MySQL, mientras que el código entre paréntesis (`45000`) clasifica la categoría general bajo el estándar universal SQL.

#### Ejemplos comunes de errores en MySQL

| Código Nativo MySQL (`MYSQL_ERRNO`) | Código Estándar (`SQLSTATE`) | Categoría del Error | Descripción breve |
| :---: | :---: | :--- | :--- |
| **`1064`** | **`42000`** | Error de sintaxis | La instrucción SQL está mal escrita o tiene un comando no reconocido en esa posición. |
| **`1146`** | **`42S02`** | Objeto inexistente | La tabla o vista consultada no existe en la base de datos seleccionada. |
| **`1054`** | **`42S22`** | Columna desconocida | Se hace referencia a un nombre de columna que no existe en la tabla. |
| **`1062`** | **`23000`** | Integridad (Duplicado) | Intento de insertar un valor repetido en una `PRIMARY KEY` o columna `UNIQUE`. |
| **`1452`** | **`23000`** | Integridad referencial | Intento de insertar o actualizar una `FOREIGN KEY` cuyo valor no existe en la tabla padre. |
| **`1048`** | **`23000`** | Integridad de dominio | Se intenta guardar `NULL` en una columna definida como `NOT NULL`. |
| **`1264`** | **`22003`** | Excepción de datos | El valor numérico o de fecha está fuera del rango permitido por el tipo de dato. |
| **`1045`** | **`28000`** | Autenticación inválida | Usuario o contraseña incorrectos al intentar conectarse al servidor (`Access denied`). |
| **`1644`** | **`45000`** | Regla de negocio | Excepción personalizada definida por el usuario/programador mediante `SIGNAL`. |
