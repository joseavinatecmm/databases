# 📘 Administración de Procedimientos Almacenados en MySQL  
Guía Didáctica para Estudiantes de Ingeniería en Computación

Los **procedimientos almacenados (Stored Procedures)** son bloques de código SQL que viven dentro del servidor MySQL.  
Comprender cómo administrarlos es fundamental en el desarrollo profesional dentro del área de bases de datos.

En esta sección aprenderás a:

- Visualizar los procedimientos existentes  
- Ver su estructura o código fuente  
- Ejecutarlos correctamente  
- Borrarlos  
- Borrar todos los procedimientos de una sola vez  
- Diagnosticar errores comunes  
- Usar delimitadores correctamente  

---

# 🟦 1. ¿Cómo visualizar los procedimientos almacenados?

## ✅ 1.1 Ver todos los procedimientos de la base de datos actual

```sql
SHOW PROCEDURE STATUS WHERE Db = DATABASE();
```

---

## ✅ 1.2 Ver solo los nombres de los procedimientos definidos

```sql
SELECT ROUTINE_NAME
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
  AND ROUTINE_SCHEMA = DATABASE();
```

---

## ✅ 1.3 Ver el código fuente de un procedimiento

```sql
SHOW CREATE PROCEDURE NombreDelProcedimiento;
```

---

# 🟦 2. ¿Cómo ejecutar procedimientos?

## 🔹 2.1 Procedimientos sin parámetros

```sql
CALL NombreProcedimiento();
```

## 🔹 2.2 Con parámetros de entrada

```sql
CALL NombreProcedimiento(valor);
```

## 🔹 2.3 Con parámetros de salida

```sql
CALL NombreProcedimiento(entrada, @salida);
SELECT @salida;
```

---

# 🟦 3. ¿Cómo borrar procedimientos?

## 🗑️ 3.1 Borrar uno

```sql
DROP PROCEDURE IF EXISTS NombreDelProcedimiento;
```

## 🗑️ 3.2 Generar comandos para borrarlos todos

```sql
SELECT 
    CONCAT('DROP PROCEDURE IF EXISTS `', ROUTINE_NAME, '`;')
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
  AND ROUTINE_SCHEMA = DATABASE();
```

## 🗑️ 3.3 Borrado automático (SQL dinámico)

```sql
SET SESSION group_concat_max_len = 10000;

SELECT 
    CONCAT('DROP PROCEDURE IF EXISTS ', GROUP_CONCAT(ROUTINE_NAME SEPARATOR ', '))
INTO @drop_cmd
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
  AND ROUTINE_SCHEMA = DATABASE();

PREPARE stmt FROM @drop_cmd;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
```

---

# 🟦 4. Diagnóstico de errores comunes

```sql
SHOW WARNINGS;
```

---

# 🟦 5. Delimitadores correctos

```sql
DELIMITER $$

CREATE PROCEDURE ejemplo()
BEGIN
    SELECT 'Hola mundo';
END$$

DELIMITER ;
```

---

# 🟦 6. Buenas prácticas

- Nombres descriptivos  
- Documentar parámetros  
- Verificar datos antes de SUM o JOIN  

---

