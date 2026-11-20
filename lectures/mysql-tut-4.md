# 🔗 Tutorial de MySQL: Consultas Multitabla con `JOIN`


## 🧠 1. Fundamentos `JOIN`

+ Cuando normalizamos una base de datos relacional, dividimos la información en múltiples tablas independientes (como `customers`, `orders`, `order_details` y `products`) para evitar redundancia y anomalías. 

+ Estas tablas quedan enlazadas mediante **llaves primarias (`PRIMARY KEY`)** y **llaves foráneas (`FOREIGN KEY`)**.

+ El operador **`JOIN`** es el mecanismo SQL que permite **reconstruir esa información fragmentada en tiempo de consulta**, combinando columnas de dos o más tablas mediante una condición lógica de coincidencia.


<!---<p align="center">
  <img src="inner-join-1.jpeg" alt="Intersección en SQL: INNER JOIN mediante PK y FK" width="95%">
</p>-->

### Clasificación esencial de los `JOIN`

* **`INNER JOIN` (Intersección):** Devuelve únicamente las filas donde existe coincidencia exacta en **ambas** tablas.


<p align="center">
  <img src="inner-join-2.jpeg" alt="Intersección en SQL: INNER JOIN mediante PK y FK" width="95%">


* **`LEFT JOIN` / `LEFT OUTER JOIN` (Inclusión izquierda):** Devuelve **todas** las filas de la tabla izquierda y las filas coincidentes de la tabla derecha. Cuando no hay coincidencia, rellena las columnas de la derecha con `NULL`.


<p align="center">
  <img src="left-join.jpeg" alt="Intersección en SQL: INNER JOIN mediante PK y FK" width="95%">

* **`RIGHT JOIN` / `RIGHT OUTER JOIN` (Inclusión derecha):** Devuelve **todas** las filas de la tabla derecha y las filas coincidentes de la tabla izquierda (o `NULL` si no existen).


<p align="center">
  <img src="right-join.jpeg" alt="Intersección en SQL: INNER JOIN mediante PK y FK" width="95%">


### 💡 ¿Para qué sirven los valores `NULL` en un `LEFT` o `RIGHT JOIN`?

En el análisis de datos, un **`NULL`** generado por un `OUTER JOIN` representa **ausencia de relación**, lo que permite descubrir información crítica que un `INNER JOIN` ocultaría:

* **Detectar inactividad (`WHERE ... IS NULL`):** Identifica clientes sin compras, productos sin ventas o transportistas sin envíos asignados para tomar decisiones de negocio (campañas de reactivación, liquidación de inventario).
* **Reportes maestros completos:** Permite listar todo un catálogo (por ejemplo, todos los empleados o transportistas) mostrando `0` en sus métricas de actividad (`COUNT(o.OrderID)`) en lugar de eliminarlos del informe.
* **Auditoría de datos:** Ayuda a localizar registros huérfanos o inconsistencias en bases de datos sin llaves foráneas estrictas.


---

## 📐 2. Sintaxis General en MySQL

En MySQL, la estructura estándar para unir dos tablas sigue esta sintaxis explícita:

```sql
SELECT 
    t1.columna1,
    t1.columna2,
    t2.columna3
FROM tabla_izquierda AS t1
[INNER | LEFT | RIGHT] JOIN tabla_derecha AS t2
    ON t1.llave_primaria = t2.llave_foranea;
```

### 💡 Reglas y buenas prácticas en MySQL

1. **Uso de alias de tabla (`t1`, `t2` o iniciales como `c`, `o`, `p`):** Abrevian la escritura y son obligatorios cuando ambas tablas tienen columnas con el mismo nombre (por ejemplo, `CustomerID` en `customers` y en `orders`) para evitar el error `Column 'CustomerID' in field list is ambiguous`.
2. **Cláusula `ON` vs. `WHERE`:** La cláusula `ON` define **cómo se enlazan las tablas** (generalmente igualando `PK = FK`), mientras que `WHERE` filtra el resultado final.
3. **La palabra clave `OUTER` es opcional:** En MySQL, escribir `LEFT JOIN` es exactamente equivalente a escribir `LEFT OUTER JOIN`.

---

## 🛠️ 3. Preparación del Escenario de Pruebas (`w3schools`)

Para visualizar claramente la diferencia entre `INNER`, `LEFT` y `RIGHT JOIN`, trabajaremos sobre las tablas ya creadas en nuestros tutoriales anteriores (`customers`, `orders`, `order_details` y `products`)[cite: 1].

Aseguraremos que exista:
* Un cliente con pedidos (`CustomerID = 90`).
* Un cliente recién registrado **sin pedidos** (`CustomerID = 91`).
* Un producto vendido (`ProductID = 501`) y un producto nuevo **sin ventas** (`ProductID = 503`).

```sql
-- 1. Verificar/crear la tabla 'customers' (si aún no está en tu esquema activo)
CREATE TABLE IF NOT EXISTS customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100),
    Address VARCHAR(150),
    City VARCHAR(100),
    PostalCode VARCHAR(20),
    Country VARCHAR(50)
);

-- 2. Verificar/crear la tabla 'order_details' (si aún no está en tu esquema activo)
CREATE TABLE IF NOT EXISTS order_details (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);

-- 3. Insertar datos de prueba (usamos INSERT IGNORE para no duplicar si ya existen)
INSERT IGNORE INTO customers (CustomerID, CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES 
    (90, 'Wilman Kala', 'Matti Karttunen', 'Keskuskatu 45', 'Helsinki', '21240', 'Finland'),
    (91, 'Wolski Zajazd', 'Zbyszek Piestrzeniewicz', 'ul. Filtrowa 68', 'Warszawa', '01-012', 'Poland');

-- Aseguramos que exista el producto 501 (vendido) y agregamos el 503 (sin ventas aún)
INSERT IGNORE INTO products (ProductID, ProductName, SupplierID, CategoryID, Unit, Price)
VALUES 
    (501, 'Queso Manchego', 12, 4, '10 - 500 g pkgs', 38.00),
    (503, 'Aceite de Oliva Extra Virgen', 12, 2, '12 - 500 ml bottles', 45.00);

-- Aseguramos la orden 20001 del cliente 90 y su detalle con el producto 501
INSERT IGNORE INTO orders (OrderID, CustomerID, EmployeeID, OrderDate, ShipperID)
VALUES (20001, 90, 5, '2025-10-23', 3);

INSERT IGNORE INTO order_details (OrderDetailID, OrderID, ProductID, Quantity)
VALUES (1, 20001, 501, 8);
```

---

## 🧩 Ejemplo 1 — `INNER JOIN` (Coincidencia Exacta)

### 🎯 Objetivo:
Obtener el listado de pedidos realizados junto con el nombre y país del cliente que los solicitó.


### Actualizar tablas

```sql
INSERT IGNORE INTO customers (CustomerID, CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES (92, 'Cardinal', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', '4006', 'Norway');

INSERT IGNORE INTO orders (OrderID, CustomerID, EmployeeID, OrderDate, ShipperID)
VALUES (20002, 92, 4, '2025-10-24', 1);

CREATE TABLE IF NOT EXISTS shippers (
    ShipperID INT PRIMARY KEY,
    ShipperName VARCHAR(100),
    Phone VARCHAR(30)
);

INSERT IGNORE INTO shippers (ShipperID, ShipperName, Phone)
VALUES 
    (1, 'Speedy Express', '(503) 555-9831'),
    (3, 'Federal Express', '(503) 555-9931'),
    (4, 'DHL', '(503) 555-4412');
```


### 💻 Consulta SQL

```sql
SELECT 
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    c.CustomerName,
    c.Country
FROM orders AS o
INNER JOIN customers AS c
    ON o.CustomerID = c.CustomerID;
```

### 📊 Resultado esperado

<p align="center">
  <img src="inner-join-3.jpeg" alt="Intersección en SQL: INNER JOIN mediante PK y FK" width="95%">



### ⚙️ ¿Por qué podemos usar los alias (`o.` y `c.`) en el `SELECT` antes de definirlos?

Aunque escribimos el `SELECT` al principio, el **procesador de consultas (*Query Processor*)** de MySQL reorganiza y ejecuta la sentencia en este orden lógico:

1. **`FROM orders AS o`**: Ubica la tabla base y registra el alias `o`.
2. **`INNER JOIN customers AS c ON ...`**: Conecta la segunda tabla, registra el alias `c` y cruza los registros.
3. **`SELECT o.OrderID, c.CustomerID...`**: **Al final**, cuando ambos alias ya existen en memoria, extrae las columnas solicitadas.


---

## 🧩 Ejemplo 2 — `LEFT JOIN` (Conservando Registros sin Pareja)

### 🎯 Objetivo:
Listar **todos** los clientes registrados en el catálogo (`customers`), mostrando sus pedidos en caso de tenerlos, o `NULL` si nunca han comprado.

### 💻 Consulta SQL

```sql
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.Country,
    o.OrderID,
    o.OrderDate
FROM customers AS c
LEFT JOIN orders AS o
    ON c.CustomerID = o.CustomerID;
```

### 🔍 Caso práctico de negocio: Detectar clientes sin compras (`IS NULL`)

### Actualizando Tablas

```sql
INSERT IGNORE INTO customers (CustomerID, CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES 
    (92, 'Cardinal', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', '4006', 'Norway'),
    (93, 'Blondel père et fils', 'Frédérique Citeaux', '24, place Kléber', 'Strasbourg', '67000', 'France'),
    (94, 'Bon app''', 'Laurence Lebihan', '12, rue des Bouchers', 'Marseille', '13008', 'France');

INSERT IGNORE INTO orders (OrderID, CustomerID, EmployeeID, OrderDate, ShipperID)
VALUES 
    (20001, 92, 4, '2025-10-23', 1),
    (20002, 93, 3, '2025-10-24', 2),
    (20003, 94, 5, '2025-10-25', 3);
```
### 📊 Resultado esperado


<p align="center">
  <img src="left-join-2.jpeg" alt="Intersección en SQL: INNER JOIN mediante PK y FK" width="95%">



Una de las aplicaciones más útiles del `LEFT JOIN` es encontrar registros huérfanos o sin actividad filtrando por `IS NULL` en la llave de la tabla derecha:

```sql
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.Country
FROM customers AS c
LEFT JOIN orders AS o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;
```

**Resultado:** Devuelve exclusivamente a `91 | Wolski Zajazd | Poland`.

---

## 🧩 Ejemplo 3 — `RIGHT JOIN` (Enfoque desde la Tabla Derecha)

### 🎯 Objetivo:
Mostrar **todos** los productos disponibles en el catálogo (`products`, tabla derecha) junto con las órdenes en las que se han vendido (`order_details`, tabla izquierda), identificando aquellos que aún no registran ventas.

### 💻 Consulta SQL

```sql
SELECT 
    od.OrderID,
    od.Quantity,
    p.ProductID,
    p.ProductName,
    p.Price
FROM order_details AS od
RIGHT JOIN products AS p
    ON od.ProductID = p.ProductID;
```

### 📊 Resultado esperado

<p align="center">
  <img src="right-join-2.jpeg" alt="Intersección en SQL: INNER JOIN mediante PK y FK" width="95%">

---

## 🧩 Ejemplo 4 — `JOIN` Múltiple (Reconstruyendo un Pedido Completo)

### 🎯 Objetivo:
Encadenar **cuatro tablas** (`orders`, `customers`, `order_details` y `products`) para generar el desglose completo de una orden de compra, incluyendo el cálculo del subtotal por producto.

### 💻 Consulta SQL

```sql
SELECT 
    o.OrderID,
    o.OrderDate,
    c.CustomerName AS Cliente,
    p.ProductName AS Producto,
    od.Quantity AS Cantidad,
    p.Price AS PrecioUnitario,
    (od.Quantity * p.Price) AS Subtotal
FROM orders AS o
INNER JOIN customers AS c 
    ON o.CustomerID = c.CustomerID
INNER JOIN order_details AS od 
    ON o.OrderID = od.OrderID
INNER JOIN products AS p 
    ON od.ProductID = p.ProductID
WHERE o.OrderID = 20001;
```
### 📊 Resultado esperado

<p align="center">
  <img src="multiple-join.jpeg" alt="Intersección en SQL: INNER JOIN mediante PK y FK" width="95%">


<!-- ## ⚠️ Nota Técnica en MySQL y Tabla Comparativa

### ¿Cómo simular un `FULL OUTER JOIN` en MySQL?

A diferencia de otros motores como PostgreSQL o SQL Server, **MySQL no soporta la sintaxis `FULL OUTER JOIN`** (que conserva registros sin pareja de *ambos* lados). Para lograr ese mismo resultado en MySQL, se combinan un `LEFT JOIN` y un `RIGHT JOIN` mediante el operador **`UNION`**:

```sql
SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM customers c
LEFT JOIN orders o ON c.CustomerID = o.CustomerID

UNION

SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM customers c
RIGHT JOIN orders o ON c.CustomerID = o.CustomerID;
```
-->

### 🧭 Resumen de Tipos de `JOIN`

| Tipo de `JOIN` | Registros devueltos | Uso principal |
| :--- | :--- | :--- |
| **`INNER JOIN`** | Solo filas con coincidencia en ambas tablas. | Consultar relaciones confirmadas (ej. pedidos con sus clientes y productos). |
| **`LEFT JOIN`** | Todas las filas de la tabla izquierda + coincidencias de la derecha (`NULL` si no hay). | Listar catálogos maestros completos o detectar registros sin actividad (`WHERE ... IS NULL`). |
| **`RIGHT JOIN`** | Todas las filas de la tabla derecha + coincidencias de la izquierda (`NULL` si no hay). | Priorizar la tabla secundaria sin alterar el orden previo de las tablas en el `FROM`. |
| **`JOIN` Múltiple** | Encadenamiento secuencial de 3 o más tablas mediante sus llaves (`PK = FK`). | Generar reportes integrales, facturas y vistas consolidadas. |
