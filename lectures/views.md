# 🧱 Tutorial SQL:  Uso de Vistas (Views) en la BD w3schools

+ A medida que nuestras consultas involucran más tablas y relaciones, las sentencias SQL se vuelven largas, complejas y difíciles de recordar. 

+ Para evitar tener que escribir la misma consulta compleja una y otra vez, SQL nos ofrece una solución muy potente: las **Vistas (Views)**.

---

## 🔍 ¿Qué es una Vista?

Una **vista** es una **tabla virtual** basada en el resultado de una consulta SQL previa. 
* **No almacena datos físicamente** (no duplica información ni consume espacio adicional en el disco como una tabla común); solo guarda la "fórmula" o consulta SQL que la genera.
* Se comporta exactamente como una tabla normal: puedes hacerle `SELECT`, aplicar filtros con `WHERE`, ordenar con `ORDER BY` o incluso unirla con otras tablas.
* Se actualiza de forma automática y en tiempo real si los datos de las tablas originales cambian.

### 🛠️ Sintaxis Básica
Para crear o modificar una vista, se utiliza la siguiente instrucción:

```sql
CREATE OR REPLACE VIEW nombre_de_la_vista AS
SELECT columnas
FROM tabla
[... JOINs, WHERE, GROUP BY, etc.];
```

> **💡 Consejo:** Usar `CREATE OR REPLACE VIEW` es una excelente práctica. Si la vista ya existe, MySQL la sobrescribirá con la nueva definición sin lanzar errores.

---

## 🚀 Ejemplos Prácticos de Vistas 

A continuación, crearemos una serie de vistas utilizando las tablas de tu base de datos `w3schools` para simplificar la obtención de reportes.

---

### Ejemplo 1: Directorio Rápido de Contactos de Clientes

+ Para los equipos de atención o ventas, no siempre es necesario ver la dirección completa o códigos postales de los clientes. 


+ Vamos a crear una vista que actúe como un directorio telefónico y de localización rápido.

```sql
CREATE OR REPLACE VIEW v_directorio_clientes AS
SELECT 
    CustomerID AS ID,
    CustomerName AS Cliente,
    ContactName AS Contacto,
    City AS Ciudad,
    Country AS Pais
FROM customers;
```

#### ¿Cómo la utilizas?
A partir de ahora, puedes consultarla como si fuera una tabla normal:
```sql
SELECT * FROM v_directorio_clientes 
WHERE Pais = 'France'
ORDER BY Cliente;
```

---

### Ejemplo 2: Catálogo de Productos con su Proveedor y Categoría

+ En la tabla `products` solo vemos números de ID para el proveedor (`SupplierID`) y la categoría (`CategoryID`). 

+ Para evitar hacer los mismos `JOINs` cada vez que queremos saber qué estamos vendiendo y quién nos lo provee, encapsulamos esta relación.

```sql
CREATE OR REPLACE VIEW v_catalogo_productos AS
SELECT 
    p.ProductID AS ID,
    p.ProductName AS Producto,
    p.Unit AS Unidad,
    p.Price AS Precio,
    c.CategoryName AS Categoria,
    s.SupplierName AS Proveedor
FROM products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
INNER JOIN suppliers AS s ON p.SupplierID = s.SupplierID;
```

#### ¿Cómo la utilizas?
Para buscar productos de una categoría específica, ya no necesitas hacer ningún `JOIN`:
```sql
SELECT Producto, Precio, Proveedor 
FROM v_catalogo_productos 
WHERE Categoria = 'Dairy Products' AND Precio < 50.00;
```

---

### Ejemplo 3: Antigüedad y Datos de los Empleados
Vamos a crear una vista que combine el nombre completo de los empleados y calcule su edad aproximada a partir de la columna `BirthDate` de la tabla `employees`, ocultando además las notas extensas que no se necesitan en un reporte de nómina básico.

```sql
CREATE OR REPLACE VIEW v_nomina_empleados AS
SELECT 
    EmployeeID AS ID,
    CONCAT(FirstName, ' ', LastName) AS NombreCompleto,
    BirthDate AS FechaNacimiento,
    TIMESTAMPDIFF(YEAR, BirthDate, CURDATE()) AS Edad,
    Notes AS NotasBreves
FROM employees;
```

#### ¿Cómo la utilizas?
```sql
-- Consultar empleados mayores de 50 años
SELECT NombreCompleto, Edad 
FROM v_nomina_empleados 
WHERE Edad > 50 
ORDER BY Edad DESC;
```

---

### Ejemplo 4: Historial de Pedidos por Cliente
Este es un nivel más elaborado donde conectamos el proceso de ventas. Queremos ver de un vistazo quién compró, cuándo compró y qué empleado procesó la orden, enlazando `orders`, `customers` y `employees`.

```sql
CREATE OR REPLACE VIEW v_historial_pedidos AS
SELECT 
    o.OrderID AS Pedido,
    o.OrderDate AS Fecha,
    c.CustomerName AS Cliente,
    c.City AS CiudadCliente,
    CONCAT(e.FirstName, ' ', e.LastName) AS AtendidoPor
FROM orders AS o
INNER JOIN customers AS c ON o.CustomerID = c.CustomerID
INNER JOIN employees AS e ON o.EmployeeID = e.EmployeeID;
```

#### ¿Cómo la utilizas?
```sql
-- Obtener los pedidos atendidos en el último año o de una fecha en específico
SELECT Pedido, Cliente, AtendidoPor 
FROM v_historial_pedidos 
WHERE Fecha >= '2025-01-01'
ORDER BY Fecha DESC;
```

---

### Ejemplo 5: Reporte de Ventas Detallado con Subtotales Financieros
En este último ejemplo, unimos cuatro tablas (`orders`, `customers`, `order_details` y `products`) para calcular el subtotal financiero de cada artículo vendido en cada orden, algo que requiere cálculos matemáticos al vuelo y múltiples relaciones de llaves.

```sql
CREATE OR REPLACE VIEW v_detalle_financiero_ventas AS
SELECT 
    o.OrderID AS Pedido,
    o.OrderDate AS Fecha,
    c.CustomerName AS Cliente,
    p.ProductName AS Producto,
    od.Quantity AS Cantidad,
    p.Price AS PrecioUnitario,
    ROUND(od.Quantity * p.Price, 2) AS Subtotal
FROM orders AS o
INNER JOIN customers AS c ON o.CustomerID = c.CustomerID
INNER JOIN order_details AS od ON o.OrderID = od.OrderID
INNER JOIN products AS p ON od.ProductID = p.ProductID;
```

#### ¿Cómo la utilizas?
```sql
-- Conocer qué ventas individuales superaron los 500 pesos/dólares
SELECT Pedido, Cliente, Producto, Subtotal 
FROM v_detalle_financiero_ventas 
WHERE Subtotal > 200.00
ORDER BY Subtotal DESC;
```

---

## 🗑️ ¿Cómo eliminar una Vista?

Si por alguna razón necesitas borrar una vista de tu base de datos, puedes hacerlo de forma segura utilizando la instrucción `DROP VIEW`:

```sql
DROP VIEW IF EXISTS v_directorio_clientes;
```

---

## 🎯 Ventajas de Utilizar Vistas en tu Proyecto
1. **Seguridad de Datos:** Puedes darle permiso a un usuario o aplicación para que consulte una vista (como `v_directorio_clientes`) sin darle acceso directo a la tabla original `customers`. De este modo, proteges información sensible.
2. **Consultas más Simples:** Los desarrolladores o analistas de datos no necesitan entender complejas relaciones ni escribir múltiples `JOINs` cada mañana. Con un simple `SELECT * FROM v_detalle_financiero_ventas` obtienen todo el panorama.
3. **Mantenimiento Centralizado:** Si en el futuro cambia la forma de calcular el subtotal o si se agrega un nuevo descuento, solo modificas la vista una vez en la base de datos, y todos los reportes o sistemas que la utilicen se actualizarán al instante sin tener que reescribir código en tus aplicaciones.
