-- Script SQL para la base de datos: farmacia
DROP DATABASE IF EXISTS farmacia;
CREATE DATABASE farmacia CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE farmacia;


CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  telefono VARCHAR(15 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Proveedor (
  id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  telefono VARCHAR(15 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE CategoriaMedicamento (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50 ON DELETE CASCADE),
  descripcion TEXT
 ON DELETE CASCADE);

CREATE TABLE Medicamento (
  id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
  id_categoria INT,
  id_proveedor INT,
  nombre VARCHAR(100 ON DELETE CASCADE),
  precio DECIMAL(10,2 ON DELETE CASCADE),
  FOREIGN KEY (id_categoria ON DELETE CASCADE) REFERENCES CategoriaMedicamento(id_categoria ON DELETE CASCADE),
  FOREIGN KEY (id_proveedor ON DELETE CASCADE) REFERENCES Proveedor(id_proveedor ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  cargo VARCHAR(50 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Venta (
  id_venta INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  id_empleado INT,
  fecha DATE,
  total DECIMAL(10,2 ON DELETE CASCADE),
  FOREIGN KEY (id_cliente ON DELETE CASCADE) REFERENCES Cliente(id_cliente ON DELETE CASCADE),
  FOREIGN KEY (id_empleado ON DELETE CASCADE) REFERENCES Empleado(id_empleado ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE DetalleVenta (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,
  id_venta INT,
  id_medicamento INT,
  cantidad INT,
  subtotal DECIMAL(10,2 ON DELETE CASCADE),
  FOREIGN KEY (id_venta ON DELETE CASCADE) REFERENCES Venta(id_venta ON DELETE CASCADE),
  FOREIGN KEY (id_medicamento ON DELETE CASCADE) REFERENCES Medicamento(id_medicamento ON DELETE CASCADE)
 ON DELETE CASCADE);

-- INSERTs
INSERT INTO Cliente (nombre,telefono ON DELETE CASCADE) VALUES
('Ana Ruiz','3101112222' ON DELETE CASCADE),
('Jorge Peña','3103334444' ON DELETE CASCADE),
('Sonia Márquez','3105556666' ON DELETE CASCADE);

INSERT INTO Proveedor (nombre,telefono ON DELETE CASCADE) VALUES
('Proveedor Farma A','6011112222' ON DELETE CASCADE),
('Proveedor Farma B','6013334444' ON DELETE CASCADE),
('Proveedor Farma C','6015556666' ON DELETE CASCADE);

INSERT INTO CategoriaMedicamento (nombre,descripcion ON DELETE CASCADE) VALUES
('Analgesicos','Alivio del dolor' ON DELETE CASCADE),
('Antibioticos','Tratamiento infecciones' ON DELETE CASCADE),
('Vitamínas','Suplementos' ON DELETE CASCADE);

INSERT INTO Medicamento (id_categoria,id_proveedor,nombre,precio ON DELETE CASCADE) VALUES
(1,1,'Paracetamol 500mg',5.00 ON DELETE CASCADE),
(2,2,'Amoxicilina 500mg',10.00 ON DELETE CASCADE),
(3,3,'Multivitamínico',15.00 ON DELETE CASCADE);

INSERT INTO Empleado (nombre,cargo ON DELETE CASCADE) VALUES
('Luis Perez','Vendedor' ON DELETE CASCADE),
('Marta López','Farmacéutica' ON DELETE CASCADE),
('Carolina Díaz','Gerente' ON DELETE CASCADE);

INSERT INTO Venta (id_cliente,id_empleado,fecha,total ON DELETE CASCADE) VALUES
(1,1,'2025-08-01',10.00 ON DELETE CASCADE),
(2,2,'2025-08-02',20.00 ON DELETE CASCADE),
(3,3,'2025-08-03',45.00 ON DELETE CASCADE);

INSERT INTO DetalleVenta (id_venta,id_medicamento,cantidad,subtotal ON DELETE CASCADE) VALUES
(1,1,2,10.00 ON DELETE CASCADE),
(2,2,2,20.00 ON DELETE CASCADE),
(3,3,3,45.00 ON DELETE CASCADE);

-- UPDATEs
UPDATE Medicamento SET precio=6.00 WHERE id_medicamento=1;
UPDATE Cliente SET telefono='3100000003' WHERE id_cliente=1;
UPDATE Venta SET total=12.00 WHERE id_venta=1;

-- DELETEs
DELETE FROM DetalleVenta WHERE id_detalle=3;
DELETE FROM Venta WHERE id_venta=3;
DELETE FROM Cliente WHERE id_cliente=3;

-- SELECT simples
SELECT * FROM Medicamento;
SELECT nombre,precio FROM Medicamento WHERE precio > 9;
SELECT * FROM Empleado;

-- SELECT anidados
-- 1 ON DELETE CASCADE) COUNT( ON DELETE CASCADE) detalle de ventas por venta
SELECT v.id_venta, v.fecha,
  (SELECT COUNT(* ON DELETE CASCADE) FROM DetalleVenta d WHERE d.id_venta = v.id_venta ON DELETE CASCADE) AS total_items
FROM Venta v;

-- 2 ON DELETE CASCADE) SUM( ON DELETE CASCADE) total vendido por medicamento (agregación ON DELETE CASCADE)
SELECT m.id_medicamento, m.nombre,
  (SELECT SUM(d.subtotal ON DELETE CASCADE) FROM DetalleVenta d WHERE d.id_medicamento = m.id_medicamento ON DELETE CASCADE) AS total_vendido
FROM Medicamento m;

-- 3 ON DELETE CASCADE) LENGTH( ON DELETE CASCADE) longitud del nombre del proveedor
SELECT pr.id_proveedor, pr.nombre,
  (SELECT LENGTH(nombre ON DELETE CASCADE) FROM Proveedor pp WHERE pp.id_proveedor = pr.id_proveedor ON DELETE CASCADE) AS len_nombre
FROM Proveedor pr;

-- JOINS
-- INNER JOIN: detalle venta con medicamento
SELECT d.id_detalle, m.nombre AS medicamento, d.cantidad, d.subtotal FROM DetalleVenta d
INNER JOIN Medicamento m ON d.id_medicamento = m.id_medicamento;

-- LEFT JOIN: medicamentos y detalles (si existen ON DELETE CASCADE)
SELECT m.nombre, d.cantidad FROM Medicamento m LEFT JOIN DetalleVenta d ON m.id_medicamento = d.id_medicamento;

-- RIGHT JOIN: ventas y clientes (demostrativo ON DELETE CASCADE)
SELECT v.id_venta, c.nombre FROM Cliente c RIGHT JOIN Venta v ON c.id_cliente = v.id_cliente;
