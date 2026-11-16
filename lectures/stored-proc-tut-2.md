# Procedimientos Almacenados en MySQL  

---

## 1. Introducción

+ Los **procedimientos almacenados (Stored Procedures)** son rutinas SQL almacenadas en el servidor MySQL. 

+ Permiten automatizar operaciones, mejorar el rendimiento y encapsular lógica de negocio directamente dentro del motor de base de datos.

+ **Agenda**: 

    - Conceptos fundamentales  
    - Sintaxis clara y didáctica  
    - Ejemplos usando tablas reales: `customers`, `orders`, `order_details`, `products`, etc.   - Cómo crear, ejecutar, ver y eliminar procedimientos almacenados  

---

## 2. ¿Qué es un Stored Procedure?

+ Un **Stored Procedure** es un conjunto de instrucciones SQL guardadas en el servidor.  
+ Se ejecuta mediante:

```sql
CALL nombre_procedimiento(parámetros);
```

### Ventajas
- Reduce tráfico entre aplicación y base de datos  
- Reutilización de código  
- Seguridad: controla acceso a datos  
- Encapsula y centraliza lógica  
- Mejor rendimiento  

---

## 3. Sintaxis general de creación

```sql
DELIMITER $$

CREATE PROCEDURE nombre_procedimiento(parámetros)
BEGIN
    -- Bloque de instrucciones SQL
END$$

DELIMITER ;
```

### ¿Por qué cambiar el delimitador?

El servidor usa `;` para terminar sentencias.  
Dentro del bloque `BEGIN ... END` se usan muchos `;`.  
Para evitar que MySQL cierre el bloque antes de tiempo, se usa temporalmente otro delimitador (`$$`).

---

## 4. Ejemplo 1 — Procedimiento básico sin parámetros
### **Mostrar todos los registros de customers**

```sql
DELIMITER $$

CREATE PROCEDURE SelectAllCustomers()
BEGIN
    SELECT * FROM customers;
END$$

DELIMITER ;
```

### Ejecución:

```sql
CALL SelectAllCustomers();
```

### Explicación:
- No recibe parámetros  
- Devuelve todos los registros  
- Es un ejemplo estándar para iniciar  

---

## 5. Ejemplo 2 — Procedimiento con parámetro IN
### **Filtrar clientes por país**

```sql
DELIMITER $$

CREATE PROCEDURE GetCustomersByCountry(IN countryName VARCHAR(50))
BEGIN
    SELECT CustomerName, City, Country
    FROM customers
    WHERE Country = countryName;
END$$

DELIMITER ;
```

### Ejecución:

```sql
CALL GetCustomersByCountry('Mexico');
```

### Explicación:
- `IN`: parámetro de solo entrada  
- Se compara directamente con la columna `Country`  

---

## 6. Ejemplo 3 — Procedimiento con parámetro OUT  
### **Contar órdenes asociadas a un cliente**

```sql
DELIMITER $$

CREATE PROCEDURE CountOrdersByCustomer(
    IN customerId INT,
    OUT totalOrders INT
)
BEGIN
    SELECT COUNT(*) INTO totalOrders
    FROM orders
    WHERE CustomerID = customerId;
END$$

DELIMITER ;
```

### Ejecución:

```sql
CALL CountOrdersByCustomer(90, @total);
SELECT @total AS TotalPedidos;
```

### Explicación:
- `OUT`: el procedimiento devuelve un valor mediante la variable `totalOrders`  
- `INTO totalOrders`: almacena el resultado dentro del parámetro OUT  
- La aplicación luego obtiene el valor con `@total`  

---

## 7. Ejemplo 4 — Procedimiento INOUT  
### **Incrementar un valor**

```sql
DELIMITER $$

CREATE PROCEDURE IncrementValue(INOUT number INT)
BEGIN
    SET number = number + 1;
END$$

DELIMITER ;
```

### Ejecución:

```sql
SET @x = 10;
CALL IncrementValue(@x);
SELECT @x;
```

### Explicación:
- `INOUT` significa que la variable es entrada y salida  
- La variable se actualiza directamente  

---

## 8. Ejemplo 5 — Procedimiento práctico usando orders, order_details y products
### **Calcular el consumo total de un cliente**

```sql
DELIMITER $$

CREATE PROCEDURE GetUserMonthlyConsumption(
    IN customerId INT,
    OUT total DECIMAL(10,2)
)
BEGIN
    SELECT 
        COALESCE(SUM(od.Quantity * p.Price), 0) INTO total
    FROM orders o
    JOIN order_details od ON o.OrderID = od.OrderID
    JOIN products p ON od.ProductID = p.ProductID
    WHERE o.CustomerID = customerId;
END$$

DELIMITER ;
```

### Ejecución:

```sql
CALL GetUserMonthlyConsumption(90, @consumo);
SELECT @consumo AS TotalGastado;
```

### Explicación:
- Relaciona órdenes con detalles y precios  
- `SUM(Quantity * Price)`: obtiene costo total  
- `COALESCE(..., 0)`: evita valores NULL  

---

## 9. Ejemplo 6 — Procedimiento con rango de fechas
### Órdenes entre fechas

```sql
DELIMITER $$

CREATE PROCEDURE GetOrdersBetweenDates(
    IN startDate DATE,
    IN endDate DATE
)
BEGIN
    SELECT *
    FROM orders
    WHERE OrderDate BETWEEN startDate AND endDate;
END$$

DELIMITER ;
```

### Ejecución:

```sql
CALL GetOrdersBetweenDates('1996-07-01', '1996-08-01');
```

---

## 10. Consultar procedimientos almacenados

### Listar todos los procedimientos:

```sql
SHOW PROCEDURE STATUS WHERE Db = DATABASE();
```

### Listar solo nombres:

```sql
SELECT ROUTINE_NAME
FROM information_schema.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
AND ROUTINE_SCHEMA = DATABASE();
```

### Ver código fuente:

```sql
SHOW CREATE PROCEDURE GetCustomersByCountry\G
```

---

## 11. Eliminar procedimientos almacenados

```sql
DROP PROCEDURE IF EXISTS CountOrdersByCustomer;
```

---

## 12. Fundamentos teóricos importantes

### ¿Por qué usar procedimientos almacenados?

| Beneficio | Explicación |
|----------|-------------|
| **Encapsulación** | Centralizan lógica de negocio |
| **Seguridad** | Permiten ejecutar lógica sin exponer tablas |
| **Rendimiento** | Menos viajes al servidor |
| **Mantenimiento** | Si cambia la lógica, se cambia solo el SP |
| **Reusabilidad** | Un SP se puede usar en múltiples aplicaciones |

