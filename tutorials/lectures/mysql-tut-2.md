# 🧠 Tutorial de MySQL: Carga de CSV, Llaves Primarias y Foráneas, Triggers y Respaldo de Base de Datos


## Agenda

1. **Definición de claves primarias y foráneas** 
2. **Cargar de archivos CSV en MySql**
3. **Creación de triggers**
4. **Respaldo la base de datos completa**.

---
## 🔑 Definir Primary Keys y Foreign Keys

### Tablas: `customers`, `orders` y `order_details`

Las **llaves primarias (PRIMARY KEY)** garantizan que cada fila tenga un identificador único,  
mientras que las **llaves foráneas (FOREIGN KEY)** establecen relaciones entre tablas,  
preservando la **integridad referencial** de la base de datos.

---

## 🧩 Ejemplo 1: Definir llaves durante la creación de las tablas

En este ejemplo, las llaves se especifican directamente dentro de las sentencias `CREATE TABLE`.

```sql
-- Tabla de clientes
CREATE TABLE customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100),
    Address VARCHAR(150),
    City VARCHAR(100),
    PostalCode VARCHAR(20),
    Country VARCHAR(50)
);

-- Tabla de órdenes
CREATE TABLE orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    ShipperID INT,
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
);

-- Tabla de detalles de órdenes
CREATE TABLE order_details (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID)
);

```



---

## 📂 Cargar archivos CSV en MySQL

### 🔹 Concepto
+ El comando `LOAD DATA INFILE` permite importar rápidamente datos desde un archivo CSV a una tabla existente.  

### 🧩 Ejemplo 1: Cargar `customers.csv`

```sql
LOAD DATA INFILE '/Users/ipepetron/DEVx/mysql/tut/customers.csv'
INTO TABLE customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(CustomerID, CustomerName, ContactName, Address, City, PostalCode, Country);
```

### 🧩 Ejemplo 2: Cargar `products.csv`

```sql
LOAD DATA INFILE '/Users/ipepetron/DEVx/mysql/tut/products.csv'
INTO TABLE products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ProductID, ProductName, SupplierID, CategoryID, Unit, Price);
```

✅ **Consejo:** Verifica siempre los encabezados del CSV y usa `IGNORE 1 ROWS` para omitirlos.

---


## ⚙️ Crear Triggers
A continuación se presentan **dos ejemplos prácticos de triggers (disparadores)** en **MySQL**, que se ejecutan automáticamente cuando se insertan registros en las tablas `orders` y `products`.

---

## 🧩 Ejemplo 1 — Trigger sobre la tabla `products`

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

DROP TRIGGER IF EXISTS before_product_insert;
DELIMITER $$

CREATE TRIGGER before_product_insert
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF NEW.Price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El precio del producto debe ser mayor que cero';
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



## 🧩 Ejemplo 2 — Trigger sobre la tabla `orders`

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

### 🧭 Conclusión

| Trigger | Evento | Tipo | Efecto |
|----------|---------|-------|--------|
| `after_order_insert` | `AFTER INSERT ON orders` | Acción automática | Inserta registro en `order_log`. |
| `before_product_insert` | `BEFORE INSERT ON products` | Validación | Impide precios no válidos. |

Estos ejemplos muestran cómo los **triggers en MySQL** permiten automatizar auditorías y mantener la integridad de los datos.
Los **triggers** ejecutan acciones automáticas ante eventos `INSERT`, `UPDATE` o `DELETE`.

---

## 💾 Respaldar una Base de Datos

El respaldo (backup) permite exportar toda la estructura y los datos de una base de datos a un archivo `.sql` utilizando el comando `mysqldump`.

### 🧩 Ejemplo 1: Respaldar toda la base de datos

En la terminal del sistema operativo:

```bash
mysqldump -u root -p nombre_base_datos > respaldo_completo.sql
```

### 🧩 Ejemplo 2: Respaldar solo algunas tablas

```bash
mysqldump -u root -p nombre_base_datos customers orders products > respaldo_parcial.sql
```

### 🔁 Restaurar desde un respaldo

```bash
mysql -u root -p nombre_base_datos < respaldo_completo.sql
```

✅ **Recomendaciones:**
- Realizar respaldos periódicos.  
- Guardar copias en ubicaciones seguras o en servicios en la nube.  
- Probar las restauraciones regularmente.

