-- Script SQL para la base de datos: supermercado
DROP DATABASE IF EXISTS supermercado;
CREATE DATABASE supermercado CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE supermercado;


-- Tablas
CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE) NOT NULL,
  direccion VARCHAR(150 ON DELETE CASCADE),
  telefono VARCHAR(15 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Proveedor (
  id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE) NOT NULL,
  telefono VARCHAR(15 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE CategoriaProducto (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50 ON DELETE CASCADE),
  descripcion TEXT
 ON DELETE CASCADE);

CREATE TABLE Producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  id_categoria INT,
  id_proveedor INT,
  nombre VARCHAR(100 ON DELETE CASCADE),
  precio DECIMAL(10,2 ON DELETE CASCADE),
  FOREIGN KEY (id_categoria ON DELETE CASCADE) REFERENCES CategoriaProducto(id_categoria ON DELETE CASCADE),
  FOREIGN KEY (id_proveedor ON DELETE CASCADE) REFERENCES Proveedor(id_proveedor ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  cargo VARCHAR(50 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Factura (
  id_factura INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  id_empleado INT,
  fecha DATE,
  total DECIMAL(10,2 ON DELETE CASCADE),
  FOREIGN KEY (id_cliente ON DELETE CASCADE) REFERENCES Cliente(id_cliente ON DELETE CASCADE),
  FOREIGN KEY (id_empleado ON DELETE CASCADE) REFERENCES Empleado(id_empleado ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE DetalleFactura (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,
  id_factura INT,
  id_producto INT,
  cantidad INT,
  subtotal DECIMAL(10,2 ON DELETE CASCADE),
  FOREIGN KEY (id_factura ON DELETE CASCADE) REFERENCES Factura(id_factura ON DELETE CASCADE),
  FOREIGN KEY (id_producto ON DELETE CASCADE) REFERENCES Producto(id_producto ON DELETE CASCADE)
 ON DELETE CASCADE);

-- INSERTs
INSERT INTO Cliente (nombre,direccion,telefono ON DELETE CASCADE) VALUES
('Luis Fernández','Cll 10 #1','3101112222' ON DELETE CASCADE),
('Sofía Ramírez','Cll 11 #2','3103334444' ON DELETE CASCADE),
('Pedro Martínez','Cll 12 #3','3105556666' ON DELETE CASCADE);

INSERT INTO Proveedor (nombre,telefono ON DELETE CASCADE) VALUES
('Proveedor A','6011112222' ON DELETE CASCADE),
('Proveedor B','6013334444' ON DELETE CASCADE),
('Proveedor C','6015556666' ON DELETE CASCADE);

INSERT INTO CategoriaProducto (nombre,descripcion ON DELETE CASCADE) VALUES
('Abarrotes','Productos secos' ON DELETE CASCADE),
('Lacteos','Productos refrigerados' ON DELETE CASCADE),
('Bebidas','Líquidos embotellados' ON DELETE CASCADE);

INSERT INTO Producto (id_categoria,id_proveedor,nombre,precio ON DELETE CASCADE) VALUES
(1,1,'Arroz 1kg',3500.00 ON DELETE CASCADE),
(2,2,'Leche 1L',4200.00 ON DELETE CASCADE),
(3,3,'Jugo 1L',3000.00 ON DELETE CASCADE);

INSERT INTO Empleado (nombre,cargo ON DELETE CASCADE) VALUES
('Ana Torres','Cajera' ON DELETE CASCADE),
('Miguel Silva','Reponedor' ON DELETE CASCADE),
('Laura Gómez','Gerente' ON DELETE CASCADE);

INSERT INTO Factura (id_cliente,id_empleado,fecha,total ON DELETE CASCADE) VALUES
(1,1,'2025-07-21',7000.00 ON DELETE CASCADE),
(2,2,'2025-07-22',4200.00 ON DELETE CASCADE),
(3,3,'2025-07-23',3000.00 ON DELETE CASCADE);

INSERT INTO DetalleFactura (id_factura,id_producto,cantidad,subtotal ON DELETE CASCADE) VALUES
(1,1,1,3500.00 ON DELETE CASCADE),
(1,2,1,3500.00 ON DELETE CASCADE),
(2,2,1,4200.00 ON DELETE CASCADE);

-- UPDATEs
UPDATE Producto SET precio=3600.00 WHERE id_producto=1;
UPDATE Cliente SET telefono='3100000001' WHERE id_cliente=1;
UPDATE Factura SET total=7100.00 WHERE id_factura=1;

-- DELETEs
DELETE FROM DetalleFactura WHERE id_detalle=3;
DELETE FROM Factura WHERE id_factura=3;
DELETE FROM Cliente WHERE id_cliente=3;

-- SELECT simples
SELECT * FROM Producto;
SELECT nombre,precio FROM Producto WHERE precio > 3000;
SELECT * FROM Empleado;

-- SELECT anidados (subconsulta con función ON DELETE CASCADE)
-- 1 ON DELETE CASCADE) COUNT( ON DELETE CASCADE) en subconsulta
SELECT c.id_cliente, c.nombre,
  (SELECT COUNT(* ON DELETE CASCADE) FROM Factura f WHERE f.id_cliente = c.id_cliente ON DELETE CASCADE) AS total_facturas
FROM Cliente c;

-- 2 ON DELETE CASCADE) MAX( ON DELETE CASCADE) para obtener fecha más reciente de factura por cliente (agregación ON DELETE CASCADE)
SELECT cl.id_cliente, cl.nombre,
  (SELECT MAX(f.fecha ON DELETE CASCADE) FROM Factura f WHERE f.id_cliente = cl.id_cliente ON DELETE CASCADE) AS ultima_factura
FROM Cliente cl;

-- 3 ON DELETE CASCADE) LENGTH( ON DELETE CASCADE) como función escalar en subconsulta
SELECT p.id_producto, p.nombre,
  (SELECT LENGTH(nombre ON DELETE CASCADE) FROM Producto pr WHERE pr.id_producto = p.id_producto ON DELETE CASCADE) AS longitud_nombre
FROM Producto p;

-- JOINs
-- INNER JOIN: Detalle con producto
SELECT df.id_detalle, pr.nombre AS producto, df.cantidad, df.subtotal
FROM DetalleFactura df
INNER JOIN Producto pr ON df.id_producto = pr.id_producto;

-- LEFT JOIN: listar productos y detalles (si existen ON DELETE CASCADE)
SELECT pr.nombre, df.cantidad FROM Producto pr LEFT JOIN DetalleFactura df ON pr.id_producto = df.id_producto;

-- RIGHT JOIN: listar facturas y clientes aunque cliente nulo (demostrativo ON DELETE CASCADE)
SELECT f.id_factura, c.nombre FROM Cliente c RIGHT JOIN Factura f ON c.id_cliente = f.id_cliente;
