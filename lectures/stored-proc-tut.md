# 📘 Stored Procedures en MySQL

## 🧱 1. ¿Qué es un Stored Procedure?

+ Un **Stored Procedure** es un bloque de instrucciones SQL almacenado en el servidor MySQL que puede ejecutarse mediante una llamada (`CALL`).  

+ Permite automatizar operaciones, encapsular lógica y mejorar rendimiento.

---

## 🧩 2. Sintaxis general

```sql
DELIMITER $$

CREATE PROCEDURE nombre_procedimiento(parámetros)
BEGIN
    -- instrucciones
END$$

DELIMITER ;
```

---

## 🧪 3. Ejemplo sin parámetros

```sql
DELIMITER $$

CREATE PROCEDURE SelectAllCustomers()
BEGIN
    SELECT * FROM customers;
END$$

DELIMITER ;
```

**Ejecutar:**

```sql
CALL SelectAllCustomers();
```

---

## 🧪 4. Ejemplo con parámetro IN

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

**Ejecutar:**

```sql
CALL GetCustomersByCountry('Mexico');
```

---

## 🧪 5. Ejemplo con parámetro OUT

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

**Ejecutar:**

```sql
CALL CountOrdersByCustomer(90, @result);
SELECT @result AS TotalDeOrdenes;
```

---

## 🧪 6. Ejemplo con parámetro INOUT

```sql
DELIMITER $$

CREATE PROCEDURE IncrementValue(INOUT number INT)
BEGIN
    SET number = number + 1;
END$$

DELIMITER ;
```

**Ejecutar:**

```sql
SET @x = 10;
CALL IncrementValue(@x);
SELECT @x;
```

---

## 🛠️ 7. Ejemplo práctico con tus tablas

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

**Ejecutar:**

```sql
CALL GetUserMonthlyConsumption(90, @consumo);
SELECT @consumo AS TotalGastado;
```

---

## 🛠️ 8. Procedimiento con dos parámetros IN

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

**Ejecutar:**

```sql
CALL GetOrdersBetweenDates('1996-07-01', '1996-08-01');
```

---

## 🕵️ 9. Ver procedimientos creados

```sql
SHOW PROCEDURE STATUS WHERE Db = DATABASE();
```

```sql
SELECT ROUTINE_NAME
FROM information_schema.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
  AND ROUTINE_SCHEMA = DATABASE();
```

```sql
SHOW CREATE PROCEDURE SelectAllCustomers\G
```

---

## 🗑️ 10. Eliminar un procedimiento

```sql
DROP PROCEDURE IF EXISTS SelectAllCustomers;
```

---

## 🧭 11. Buenas prácticas

- Usa nombres claros.
- Documenta con comentarios.
- Maneja NULL con COALESCE.
- Divide procedimientos grandes.

---

Fin del documento.
