# 🛠️ Guía Práctica de Gestión en MySQL: DDL, DML y DQL
> **Caso de Estudio:** Despliegue, Operación y Analítica de la plataforma `tienda_virtual`.  
> **Entorno:** Servidor MySQL 8.x / MariaDB | Terminal Bash, Zsh y PowerShell.

---

## 📌 Tabla de Contenidos
1. [⚙️ Módulo 1: Puesta en Marcha del Servidor y Conexión](#️-módulo-1-puesta-en-marcha-del-servidor-y-conexión)
2. [🧭 Módulo 2: Reconocimiento del Entorno y Reglas Esenciales](#-módulo-2-reconocimiento-del-entorno-y-reglas-esenciales)
3. [🏗️ Módulo 3: Lenguaje de Definición de Datos (DDL) — Construcción del Esquema](#️-módulo-3-lenguaje-de-definición-de-datos-ddl--construcción-del-esquema)
4. [🔄 Módulo 4: Lenguaje de Manipulación de Datos (DML) — Gestión Operativa](#-módulo-4-lenguaje-de-manipulación-de-datos-dml--gestión-operativa)
5. [🔍 Módulo 5: Lenguaje de Consulta de Datos (DQL) — Extracción y Analítica](#-módulo-5-lenguaje-de-consulta-de-datos-dql--extracción-y-analítica)
6. [📋 Matriz de Comandos Rápidos](#-matriz-de-comandos-rápidos)

---

## ⚙️ Módulo 1: Puesta en Marcha del Servidor y Conexión

Antes de emitir sentencias SQL, el proceso del motor de base de datos (`mysqld`) debe estar activo en el sistema operativo anfitrión.

### 1.1 Inicio del Servicio MySQL

```bash
# 🍏 En macOS (mediante Homebrew)
brew services start mysql

# 🐧 En Linux (Ubuntu / Debian / RHEL vía systemd)
sudo systemctl start mysql

# 🪟 En Windows (PowerShell o Símbolo del Sistema como Administrador)
net start mysql
```

---

### 1.2 Métodos de Conexión desde la Terminal

El cliente de línea de comandos `mysql` establece un canal bidireccional mediante sockets de dominio local o conexiones TCP/IP.

#### Conexión Estándar (Recomendada con Contraseña)
Solicita la clave de acceso de manera enmascarada (los caracteres no se mostrarán en pantalla mientras se escribe):
```bash
mysql -u root -p
```

#### Conexión Rápida (Entornos locales sin contraseña configurada)
```bash
mysql -u root
```

#### Conexión Remota o Local con Host y Puerto Específico
```bash
mysql -h 127.0.0.1 -P 3306 -u root -p
```

> [!NOTE]
> **Diferenciación de parámetros de red y credenciales:**  
> - `-P` *(Mayúscula)*: Especifica el **Puerto** de red de escucha (por defecto `3306`).  
> - `-p` *(Minúscula)*: Notifica al cliente que solicite la **Password** (contraseña).

---

## 🧭 Módulo 2: Reconocimiento del Entorno y Reglas Esenciales

Al ingresar a la consola, el cursor responderá con el prompt interactivo `mysql>`.

```
Welcome to the MySQL monitor. Commands end with ; or \g.
Server version: 8.0.36 MySQL Community Server - GPL
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

### 2.1 Inspección de Catálogos Existentes
Para listar los contenedores de datos iniciales del sistema:

```sql
SHOW DATABASES;
```

**Salida Esperada:**
```text
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.01 sec)
```

### 2.2 Tres Reglas Fundamentales del Cliente MySQL

* 🔤 **El Terminador Obligatorio (`;`):**  
  Toda sentencia requiere de un punto y coma al final. Si presionas `Enter` y aparece `->`, significa que la instrucción continúa abierta esperando su delimitador:
  ```text
  mysql> SELECT 1
      -> ;
  ```
* 🔠 **Sensibilidad a Mayúsculas y Minúsculas:**  
  Las palabras clave de SQL (`SELECT`, `CREATE`, `TABLE`) no distinguen entre mayúsculas y minúsculas. Sin embargo, los nombres de tablas y bases de datos en servidores de producción (Linux) son estrictamente sensibles a mayúsculas/minúsculas debido al sistema de archivos subyacente. La convención recomendada es escribir palabras clave en **MAYÚSCULAS** y nombres de objetos en **minúsculas o CamelCase controlado**.
* 🚫 **Interrupción de Comandos (`\c`):**  
  Si cometes un error de digitación en una consulta multilínea, cancela la ejecución escribiendo `\c` antes de presionar `Enter`.

---

## 🏗️ Módulo 3: Lenguaje de Definición de Datos (DDL) — Construcción del Esquema

El sublenguaje **DDL (Data Definition Language)** comprende las instrucciones que crean, modifican y destruyen las estructuras lógicas de la base de datos (esquemas, tablas, columnas y restricciones de integridad).

```text
┌────────────────────────┐                   ┌────────────────────────┐
│        CLIENTES        │                   │       PRODUCTOS        │
├────────────────────────┤                   ├────────────────────────┤
│ PK  id_cliente     INT │                   │ PK  id_producto    INT │
│     nombre VARCHAR(100)│                   │     nombre VARCHAR(100)│
│     email  VARCHAR(100)│                   │     categoria  VARCHAR │
│     ciudad VARCHAR(50) │                   │     precio     DECIMAL │
│     activo     TINYINT │                   │     stock          INT │
│     telefono   VARCHAR │                   └───────────┬────────────┘
└───────────┬────────────┘                               │
            │ 1                                          │ 1
            │                                            │
            │ N                                          │ N
       ┌────┴────────────────────────────────────────────┴────┐
       │                       PEDIDOS                        │
       ├──────────────────────────────────────────────────────┤
       │ PK   id_pedido    INT                                │
       │ FK1  id_cliente   INT  ──────────────────────────────┤ (Vínculo con Clientes)
       │ FK2  id_producto  INT  ──────────────────────────────┤ (Vínculo con Productos)
       │      fecha        DATE                               │
       │      total        DECIMAL(10,2)                      │
       └──────────────────────────────────────────────────────┘

```

---

### 3.1 Creación y Activación del Espacio de Trabajo

* **Propósito:** Alojar todas las entidades comerciales bajo un contenedor unificado.
* **Sintaxis:**
  ```sql
  CREATE DATABASE [IF NOT EXISTS] nombre_bd
      [DEFAULT CHARACTER SET codificacion]
      [DEFAULT COLLATE regla_ordenacion];
  USE nombre_bd;
  ```
* **Ejecución (Forma Simple y Directa):**
  ```sql
  CREATE DATABASE tienda_virtual;
  USE tienda_virtual;
  ```
* **Verificación:**
  ```sql
  SELECT DATABASE();
  ```
  ```text
  +----------------+
  | DATABASE()     |
  +----------------+
  | tienda_virtual |
  +----------------+
  ```

---

### 3.2 Creación de la Entidad `Clientes` (Fundamentos de Tipos de Datos)

* **Propósito:** Almacenar los datos de contacto y estado operativo de los usuarios compradores.
* **Criterio de Selección de Tipos:**
  * `INT`: Clave numérica primaria única.
  * `VARCHAR(100)`: Texto de longitud variable (guarda nombres y correos ocupando solo los caracteres escritos).
  * `TINYINT`: Número entero pequeño para registrar el estado (`1` activo, `0` inactivo).
* **Ejecución (Forma Simple):**
  ```sql
  CREATE TABLE Clientes (
      id_cliente INT PRIMARY KEY,
      nombre VARCHAR(100) NOT NULL,
      email VARCHAR(100) NOT NULL,
      ciudad VARCHAR(50) DEFAULT 'Guadalajara',
      activo TINYINT DEFAULT 1
  );
  ```
* **Verificación:**
  ```sql
  DESCRIBE Clientes;
  ```
  ```text
  +------------+--------------+------+-----+-------------+-------+
  | Field      | Type         | Null | Key | Default     | Extra |
  +------------+--------------+------+-----+-------------+-------+
  | id_cliente | int          | NO   | PRI | NULL        |       |
  | nombre     | varchar(100) | NO   |     | NULL        |       |
  | email      | varchar(100) | NO   |     | NULL        |       |
  | ciudad     | varchar(50)  | YES  |     | Guadalajara |       |
  | activo     | tinyint      | YES  |     | 1           |       |
  +------------+--------------+------+-----+-------------+-------+
  ```

---

### 3.3 Creación de la Entidad `Productos` (Exactitud Numérica)

* **Propósito:** Registrar el inventario tecnológico garantizando precisión en precios.
* **Criterio de Selección de Tipos:**
  * `DECIMAL(10,2)`: Importes monetarios con centavos exactos sin errores de aproximación.
  * `INT`: Cantidad entera de artículos en almacén.
* **Ejecución (Forma Simple):**
  ```sql
  CREATE TABLE Productos (
      id_producto INT PRIMARY KEY,
      nombre VARCHAR(100) NOT NULL,
      categoria VARCHAR(50),
      precio DECIMAL(10,2) NOT NULL,
      stock INT DEFAULT 0
  );
  ```
* **Verificación:**
  ```sql
  SHOW TABLES;
  ```
  ```text
  +--------------------------+
  | Tables_in_tienda_virtual |
  +--------------------------+
  | Clientes                 |
  | Productos                |
  +--------------------------+
  ```

---

### 3.4 Creación de la Entidad `Pedidos` (Relación mediante Clave Foránea)

* **Propósito:** Registrar las órdenes de compra asociando cada venta a un cliente existente.
* **Criterio de Selección de Tipos:**
  * `DATE`: Fecha de la orden (`AAAA-MM-DD`).
  * `FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)`: Asegura que no se generen pedidos con clientes inexistentes.
* **Ejecución (Forma Simple):**
  ```sql
  CREATE TABLE Pedidos (
      id_pedido INT PRIMARY KEY,
      id_cliente INT NOT NULL,
      fecha DATE NOT NULL,
      total DECIMAL(10,2) DEFAULT 0.00,
      FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
  );
  ```
* **Verificación:**
  ```sql
  SHOW TABLES;
  ```
  ```text
  +--------------------------+
  | Tables_in_tienda_virtual |
  +--------------------------+
  | Clientes                 |
  | Pedidos                  |
  | Productos                |
  +--------------------------+
  ```

---

### 3.5 Evolución de Esquema: Comando `ALTER TABLE`

* **Propósito:** Añadir un campo de contacto a la tabla `Clientes` sin tener que recrearla.
* **Sintaxis:**
  ```sql
  ALTER TABLE nombre_tabla ADD COLUMN nueva_columna TIPO [RESTRICCIONES];
  ```
* **Ejecución (Forma Simple):**
  ```sql
  ALTER TABLE Clientes ADD telefono VARCHAR(20);
  ```
* **Verificación:**
  ```sql
  DESCRIBE Clientes;
  ```
  ```text
  +------------+--------------+------+-----+-------------+-------+
  | Field      | Type         | Null | Key | Default     | Extra |
  +------------+--------------+------+-----+-------------+-------+
  | id_cliente | int          | NO   | PRI | NULL        |       |
  | nombre     | varchar(100) | NO   |     | NULL        |       |
  | email      | varchar(100) | NO   |     | NULL        |       |
  | ciudad     | varchar(50)  | YES  |     | Guadalajara |       |
  | activo     | tinyint      | YES  |     | 1           |       |
  | telefono   | varchar(20)  | YES  |     | NULL        |       |
  +------------+--------------+------+-----+-------------+-------+
  ```

---

### 3.6 Eliminación de Tablas: Comando `DROP TABLE`

* **Propósito:** Eliminar de forma permanente tablas transitorias o de respaldo.
* **Sintaxis:**
  ```sql
  DROP TABLE [IF EXISTS] nombre_tabla;
  ```
* **Ejecución (Forma Simple):**
  ```sql
  DROP TABLE IF EXISTS Auditoria_Temp;
  ```
* **Verificación:** MySQL reporta `Query OK, 0 rows affected`, garantizando que la sesión puede continuar sin interrupciones.

---

## 🔄 Módulo 4: Lenguaje de Manipulación de Datos (DML) — Gestión Operativa

El sublenguaje **DML (Data Manipulation Language)** permite poblar, actualizar y depurar las filas de las tablas sin modificar la estructura del esquema.

---

### 4.1 Inserción de un Registro Individual

* **Propósito:** Dar de alta el primer cliente (`Ana Ruiz`) en el sistema.
* **Sintaxis:**
  ```sql
  INSERT INTO tabla (col1, col2, ...) VALUES (val1, val2, ...);
  ```
* **Ejecución (Forma Simple):**
  ```sql
  INSERT INTO Clientes (id_cliente, nombre, email, ciudad, activo, telefono)
  VALUES (1, 'Ana Ruiz', 'ana@mail.com', 'Guadalajara', 1, '3311223344');
  ```
* **Verificación:**
  ```sql
  SELECT * FROM Clientes;
  ```
  ```text
  +------------+----------+--------------+-------------+--------+------------+
  | id_cliente | nombre   | email        | ciudad      | activo | telefono   |
  +------------+----------+--------------+-------------+--------+------------+
  |          1 | Ana Ruiz | ana@mail.com | Guadalajara |      1 | 3311223344 |
  +------------+----------+--------------+-------------+--------+------------+
  ```

---

### 4.2 Inserción Masiva (*Bulk Insert*) en `Clientes`

* **Propósito:** Registrar varios clientes en un solo comando separando los valores con comas.
* **Ejecución (Forma Simple):**
  ```sql
  INSERT INTO Clientes (id_cliente, nombre, email, ciudad, activo, telefono) VALUES
  (2, 'Carlos Mora', 'carlos@mail.com', 'Zapopan', 1, '3344556677'),
  (3, 'Beatriz Silva', 'beatriz@mail.com', 'Tlaquepaque', 1, '3399887766'),
  (4, 'David Vega', 'david@mail.com', 'Guadalajara', 0, '3322446688');
  ```
* **Verificación:**
  ```sql
  SELECT id_cliente, nombre, ciudad, activo FROM Clientes;
  ```
  ```text
  +------------+---------------+-------------+--------+
  | id_cliente | nombre        | ciudad      | activo |
  +------------+---------------+-------------+--------+
  |          1 | Ana Ruiz      | Guadalajara |      1 |
  |          2 | Carlos Mora   | Zapopan     |      1 |
  |          3 | Beatriz Silva | Tlaquepaque |      1 |
  |          4 | David Vega    | Guadalajara |      0 |
  +------------+---------------+-------------+--------+
  ```

---

### 4.3 Carga del Catálogo en `Productos`

* **Propósito:** Ingresar 5 artículos con sus precios y existencias iniciales.
* **Ejecución (Forma Simple):**
  ```sql
  INSERT INTO Productos (id_producto, nombre, categoria, precio, stock) VALUES
  (101, 'Teclado Mecánico', 'Periféricos', 1200.00, 25),
  (102, 'Ratón Óptico', 'Periféricos', 450.00, 40),
  (103, 'Monitor 27 Pulgadas', 'Hardware', 4800.00, 10),
  (104, 'Memoria RAM 16GB', 'Hardware', 1350.00, 18),
  (105, 'Auriculares Pro', 'Audio', 850.00, 15);
  ```
* **Verificación:**
  ```sql
  SELECT id_producto, nombre, categoria, precio, stock FROM Productos;
  ```
  ```text
  +-------------+---------------------+-------------+---------+-------+
  | id_producto | nombre              | categoria   | precio  | stock |
  +-------------+---------------------+-------------+---------+-------+
  |         101 | Teclado Mecánico    | Periféricos | 1200.00 |    25 |
  |         102 | Ratón Óptico        | Periféricos |  450.00 |    40 |
  |         103 | Monitor 27 Pulgadas | Hardware    | 4800.00 |    10 |
  |         104 | Memoria RAM 16GB    | Hardware    | 1350.00 |    18 |
  |         105 | Auriculares Pro     | Audio       |  850.00 |    15 |
  +-------------+---------------------+-------------+---------+-------+
  ```

---

### 4.4 Registro de Órdenes en `Pedidos`

* **Propósito:** Registrar las ventas realizadas usando los IDs de clientes existentes.
* **Ejecución (Forma Simple):**
  ```sql
  INSERT INTO Pedidos (id_pedido, id_cliente, fecha, total) VALUES
  (501, 1, '2026-03-01', 1650.00),
  (502, 2, '2026-03-02', 4800.00),
  (503, 1, '2026-03-05', 1350.00),
  (504, 3, '2026-03-08', 850.00);
  ```
* **Verificación:**
  ```sql
  SELECT * FROM Pedidos;
  ```
  ```text
  +-----------+------------+------------+---------+
  | id_pedido | id_cliente | fecha      | total   |
  +-----------+------------+------------+---------+
  |       501 |          1 | 2026-03-01 | 1650.00 |
  |       502 |          2 | 2026-03-02 | 4800.00 |
  |       503 |          1 | 2026-03-05 | 1350.00 |
  |       504 |          3 | 2026-03-08 |  850.00 |
  +-----------+------------+------------+---------+
  ```

---

### 4.5 Actualización Aritmética: Comando `UPDATE`

* **Propósito:** Aplicar un aumento del 10% únicamente a los productos de la categoría `Periféricos`.
* **Sintaxis:**
  ```sql
  UPDATE nombre_tabla SET columna = expresion WHERE condicion;
  ```
* **Ejecución (Forma Simple):**
  ```sql
  UPDATE Productos
  SET precio = precio * 1.10
  WHERE categoria = 'Periféricos';
  ```
* **Verificación:**
  ```sql
  SELECT id_producto, nombre, categoria, precio FROM Productos WHERE categoria = 'Periféricos';
  ```
  ```text
  +-------------+------------------+-------------+---------+
  | id_producto | nombre           | categoria   | precio  |
  +-------------+------------------+-------------+---------+
  |         101 | Teclado Mecánico | Periféricos | 1320.00 |
  |         102 | Ratón Óptico     | Periféricos |  495.00 |
  +-------------+------------------+-------------+---------+
  ```

---

### 4.6 Actualización de Múltiples Columnas

* **Propósito:** Cambiar simultáneamente la ciudad y el teléfono del cliente con ID `2`.
* **Ejecución (Forma Simple):**
  ```sql
  UPDATE Clientes
  SET ciudad = 'Guadalajara', telefono = '3300112233'
  WHERE id_cliente = 2;
  ```
* **Verificación:**
  ```sql
  SELECT id_cliente, nombre, ciudad, telefono FROM Clientes WHERE id_cliente = 2;
  ```
  ```text
  +------------+-------------+-------------+------------+
  | id_cliente | nombre      | ciudad      | telefono   |
  +------------+-------------+-------------+------------+
  |          2 | Carlos Mora | Guadalajara | 3300112233 |
  +------------+-------------+-------------+------------+
  ```

---

### 4.7 Eliminación Condicionada: Comando `DELETE FROM`

* **Propósito:** Remover a los clientes que tengan estado inactivo (`activo = 0`), eliminando a `David Vega`.
* **Sintaxis:**
  ```sql
  DELETE FROM nombre_tabla WHERE condicion;
  ```
* **Ejecución (Forma Simple):**
  ```sql
  DELETE FROM Clientes
  WHERE activo = 0;
  ```
* **Verificación:**
  ```sql
  SELECT id_cliente, nombre, activo FROM Clientes;
  ```
  ```text
  +------------+---------------+--------+
  | id_cliente | nombre        | activo |
  +------------+---------------+--------+
  |          1 | Ana Ruiz      |      1 |
  |          2 | Carlos Mora   |      1 |
  |          3 | Beatriz Silva |      1 |
  +------------+---------------+--------+
  ```

> [!WARNING]
> **Atención:** Si ejecutas `DELETE FROM Clientes;` sin la cláusula `WHERE`, borrarás todas las filas de la tabla.

---

### 4.8 Eliminación por Rango con `BETWEEN`

* **Propósito:** Borrar artículos con existencias críticas que estén en el rango de 1 a 12 unidades (se elimina el `Monitor 27 Pulgadas`).
* **Ejecución (Forma Simple):**
  ```sql
  DELETE FROM Productos
  WHERE stock BETWEEN 1 AND 12;
  ```
* **Verificación:**
  ```sql
  SELECT id_producto, nombre, stock FROM Productos;
  ```
  ```text
  +-------------+------------------+-------+
  | id_producto | nombre           | stock |
  +-------------+------------------+-------+
  |         101 | Teclado Mecánico |    25 |
  |         102 | Ratón Óptico     |    40 |
  |         104 | Memoria RAM 16GB |    18 |
  |         105 | Auriculares Pro  |    15 |
  +-------------+------------------+-------+
  ```

---

## 🔍 Módulo 5: Lenguaje de Consulta de Datos (DQL) — Extracción y Analítica

El sublenguaje **DQL (Data Query Language)** se materializa a través de la sentencia `SELECT`. Su ejecución no muta los datos almacenados en disco: genera una estructura temporal en memoria volátil denominada **ResultSet**.

---

### 5.1 Proyección Vertical Básica

* **Propósito:** Extraer únicamente las columnas de interés (`nombre` y `ciudad`).
* **Sintaxis:**
  ```sql
  SELECT col1, col2 FROM nombre_tabla;
  ```
* **Ejecución (Forma Simple):**
  ```sql
  SELECT nombre, ciudad
  FROM Clientes;
  ```
* **Resultado:**
  ```text
  +---------------+-------------+
  | nombre        | ciudad      |
  +---------------+-------------+
  | Ana Ruiz      | Guadalajara |
  | Carlos Mora   | Guadalajara |
  | Beatriz Silva | Tlaquepaque |
  +---------------+-------------+
  ```

---

### 5.2 Renombrado de Columnas con Alias (`AS`)

* **Propósito:** Mostrar encabezados más claros en el reporte de resultados sin cambiar los nombres de las columnas en la tabla.
* **Ejecución (Forma Simple):**
  ```sql
  SELECT nombre AS Articulo, precio AS Precio_Unitario_MXN
  FROM Productos;
  ```
* **Resultado:**
  ```text
  +------------------+---------------------+
  | Articulo         | Precio_Unitario_MXN |
  +------------------+---------------------+
  | Teclado Mecánico |             1320.00 |
  | Ratón Óptico     |              495.00 |
  | Memoria RAM 16GB |             1350.00 |
  | Auriculares Pro  |              850.00 |
  +------------------+---------------------+
  ```

---

### 5.3 Restricción Horizontal con `WHERE`

* **Propósito:** Filtrar para obtener solo los clientes que radiquen en `Guadalajara`.
* **Ejecución (Forma Simple):**
  ```sql
  SELECT id_cliente, nombre, ciudad
  FROM Clientes
  WHERE ciudad = 'Guadalajara';
  ```
* **Resultado:**
  ```text
  +------------+-------------+-------------+
  | id_cliente | nombre      | ciudad      |
  +------------+-------------+-------------+
  |          1 | Ana Ruiz    | Guadalajara |
  |          2 | Carlos Mora | Guadalajara |
  +------------+-------------+-------------+
  ```

---

### 5.4 Filtro Compuesto con `AND`

* **Propósito:** Encontrar artículos que pertenezcan a `Periféricos` y que al mismo tiempo tengan un precio superior a 500.
* **Ejecución (Forma Simple):**
  ```sql
  SELECT id_producto, nombre, categoria, precio
  FROM Productos
  WHERE categoria = 'Periféricos' AND precio > 500.00;
  ```
* **Resultado:**
  ```text
  +-------------+------------------+-------------+---------+
  | id_producto | nombre           | categoria   | precio  |
  +-------------+------------------+-------------+---------+
  |         101 | Teclado Mecánico | Periféricos | 1320.00 |
  +-------------+------------------+-------------+---------+
  ```

---

### 5.5 Filtro Alternativo con `OR`

* **Propósito:** Mostrar los productos que pertenezcan a `Audio` o que tengan 20 o más unidades en existencias.
* **Ejecución (Forma Simple):**
  ```sql
  SELECT nombre, categoria, stock
  FROM Productos
  WHERE categoria = 'Audio' OR stock >= 20;
  ```
* **Resultado:**
  ```text
  +------------------+-------------+-------+
  | nombre           | categoria   | stock |
  +------------------+-------------+-------+
  | Teclado Mecánico | Periféricos |    25 |
  | Ratón Óptico     | Periféricos |    40 |
  | Auriculares Pro  | Audio       |    15 |
  +------------------+-------------+-------+
  ```

---

### 5.6 Búsqueda por Patrones con `LIKE`

* **Propósito:** Encontrar todos los clientes cuyo correo electrónico termine en `@mail.com`.
* **Ejecución (Forma Simple):**
  ```sql
  SELECT nombre, email
  FROM Clientes
  WHERE email LIKE '%@mail.com';
  ```
* **Resultado:**
  ```text
  +---------------+------------------+
  | nombre        | email            |
  +---------------+------------------+
  | Ana Ruiz      | ana@mail.com     |
  | Carlos Mora   | carlos@mail.com  |
  | Beatriz Silva | beatriz@mail.com |
  +---------------+------------------+
  ```

---

### 5.7 Conteo por Grupos con `GROUP BY` y `COUNT(*)`

* **Propósito:** Contar cuántos clientes registrados pertenecen a cada ciudad.
* **Ejecución (Forma Simple):**
  ```sql
  SELECT ciudad, COUNT(*) AS Total_Clientes
  FROM Clientes
  GROUP BY ciudad;
  ```
* **Resultado:**
  ```text
  +-------------+----------------+
  | ciudad      | Total_Clientes |
  +-------------+----------------+
  | Guadalajara |              2 |
  | Tlaquepaque |              1 |
  +-------------+----------------+
  ```

---

### 5.8 Suma de Totales con `GROUP BY` y `SUM()`

* **Propósito:** Sumar el monto total de compras acumulado por cada cliente en la tabla `Pedidos`.
* **Ejecución (Forma Simple):**
  ```sql
  SELECT id_cliente, SUM(total) AS Gasto_Total
  FROM Pedidos
  GROUP BY id_cliente;
  ```
* **Resultado:**
  ```text
  +------------+-------------+
  | id_cliente | Gasto_Total |
  +------------+-------------+
  |          1 |     3000.00 |
  |          2 |     4800.00 |
  |          3 |      850.00 |
  +------------+-------------+
  ```

---

### 5.9 Filtro sobre Grupos Calculados con `HAVING`

* **Propósito:** Mostrar únicamente los clientes cuyo total gastado acumulado sea igual o mayor a 2000.00.
* **Ejecución (Forma Simple):**
  ```sql
  SELECT id_cliente, SUM(total) AS Gasto_Total
  FROM Pedidos
  GROUP BY id_cliente
  HAVING SUM(total) >= 2000.00;
  ```
* **Resultado:**
  ```text
  +------------+-------------+
  | id_cliente | Gasto_Total |
  +------------+-------------+
  |          1 |     3000.00 |
  |          2 |     4800.00 |
  +------------+-------------+
  ```

---

## 📋 Matriz de Comandos Rápidos

| Sublenguaje | Comando / Cláusula | Propósito Operativo | Forma Simple Ejecutada |
| :--- | :--- | :--- | :--- |
| **DDL** | `CREATE DATABASE` | Inicializa el contenedor del esquema | `CREATE DATABASE tienda_virtual;` |
| **DDL** | `CREATE TABLE` | Define estructura, tipos y llaves | `CREATE TABLE Clientes (...);` |
| **DDL** | `ALTER TABLE` | Añade columnas sin perder datos | `ALTER TABLE Clientes ADD telefono VARCHAR(20);` |
| **DDL** | `DROP TABLE` | Suprime estructuras de forma definitiva | `DROP TABLE IF EXISTS Auditoria_Temp;` |
| **DML** | `INSERT INTO` | Guarda registros en las tablas | `INSERT INTO Clientes (...) VALUES (...);` |
| **DML** | `UPDATE ... SET` | Modifica valores de atributos | `UPDATE Productos SET precio = precio * 1.10 ...;` |
| **DML** | `DELETE FROM` | Elimina registros según condición | `DELETE FROM Clientes WHERE activo = 0;` |
| **DQL** | `SELECT ... FROM` | Consulta columnas en memoria | `SELECT nombre, ciudad FROM Clientes;` |
| **DQL** | `WHERE ... LIKE` | Filtra filas por igualdad o texto | `WHERE ciudad = 'Guadalajara'` / `LIKE '%@mail.com'` |
| **DQL** | `GROUP BY / HAVING` | Agrupa tuplas y filtra totales | `GROUP BY ciudad` / `HAVING SUM(total) >= 2000.00` |
