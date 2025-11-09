# 🧱 Tutorial MySQL — Creación de Tablas y Carga de Archivos CSV


## 🧩 Sección 1. Creación de las tablas

A continuación se definen las sentencias SQL para crear todas las tablas del sistema.

```sql
-- Tabla: customers
CREATE TABLE customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100),
    Address VARCHAR(150),
    City VARCHAR(50),
    PostalCode VARCHAR(15),
    Country VARCHAR(50)
);

-- Tabla: employees
CREATE TABLE employees (
    EmployeeID INT PRIMARY KEY,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL,
    Notes TEXT CHARACTER SET utf8mb4
);

-- Tabla: shippers
CREATE TABLE shippers (
    ShipperID INT PRIMARY KEY,
    ShipperName VARCHAR(100) NOT NULL,
    Phone VARCHAR(30)
);

-- Tabla: suppliers
CREATE TABLE suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100),
    Address VARCHAR(150),
    City VARCHAR(50),
    PostalCode VARCHAR(15),
    Country VARCHAR(50),
    Phone VARCHAR(30)
);

-- Tabla: products
CREATE TABLE products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    Unit VARCHAR(50),
    Price DECIMAL(10,2),
    FOREIGN KEY (SupplierID) REFERENCES suppliers(SupplierID)
);

-- Tabla: orders
CREATE TABLE orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    OrderDate DATE,
    ShipperID INT,
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES employees(EmployeeID),
    FOREIGN KEY (ShipperID) REFERENCES shippers(ShipperID)
);

-- Tabla: order_details
CREATE TABLE order_details (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);
```

---

## 📂 Sección 2. Carga de archivos CSV

Todos los archivos `.csv` se encuentran en la siguiente ruta:

```
/Users/ipepetron/DEVx/mysql/tut/
```

Antes de cargar los archivos, habilita el uso de archivos locales en MySQL:

```sql
SET GLOBAL local_infile = 1;
```

Estás utilizando el cliente con la opción `--local-infile=1`:
>    ```bash
>    mysql --local-infile=1 -u root
>   

---

### 🔹 Cargar `customers.csv`

```sql
LOAD DATA LOCAL INFILE '/Users/ipepetron/DEVx/mysql/tut/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(CustomerID, CustomerName, ContactName, Address, City, PostalCode, Country);
```

---

### 🔹 Cargar `employees.csv`

```sql
LOAD DATA LOCAL INFILE '/Users/ipepetron/DEVx/mysql/tut/employees.csv'
INTO TABLE employees
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(EmployeeID, LastName, FirstName, BirthDate, Notes);
```

---

### 🔹 Cargar `orders.csv`

```sql
LOAD DATA LOCAL INFILE '/Users/ipepetron/DEVx/mysql/tut/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(OrderID, CustomerID, EmployeeID, OrderDate, ShipperID);
```

---

### 🔹 Cargar `order_details.csv`

```sql
LOAD DATA LOCAL INFILE '/Users/ipepetron/DEVx/mysql/tut/order_details.csv'
INTO TABLE order_details
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(OrderDetailID, OrderID, ProductID, Quantity);
```

---

### 🔹 Cargar `products.csv`

```sql
LOAD DATA LOCAL INFILE '/Users/ipepetron/DEVx/mysql/tut/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ProductID, ProductName, SupplierID, CategoryID, Unit, Price);
```

---

### 🔹 Cargar `shippers.csv`

```sql
LOAD DATA LOCAL INFILE '/Users/ipepetron/DEVx/mysql/tut/shippers.csv'
INTO TABLE shippers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ShipperID, ShipperName, Phone);
```

---

### 🔹 Cargar `suppliers.csv`

```sql
LOAD DATA LOCAL INFILE '/Users/ipepetron/DEVx/mysql/tut/suppliers.csv'
INTO TABLE suppliers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(SupplierID, SupplierName, ContactName, Address, City, PostalCode, Country, Phone);
```

---

## ✅ Verificación de carga

Ejecuta para verificar cuántos registros se cargaron correctamente:

```sql
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM employees;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_details;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM shippers;
SELECT COUNT(*) FROM suppliers;
```
