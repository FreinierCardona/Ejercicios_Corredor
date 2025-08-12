-- Script SQL para la base de datos: taller_mecanico
DROP DATABASE IF EXISTS taller_mecanico;
CREATE DATABASE taller_mecanico CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE taller_mecanico;


CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  telefono VARCHAR(15 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Vehiculo (
  id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  placa VARCHAR(10 ON DELETE CASCADE),
  marca VARCHAR(50 ON DELETE CASCADE),
  modelo VARCHAR(50 ON DELETE CASCADE),
  FOREIGN KEY (id_cliente ON DELETE CASCADE) REFERENCES Cliente(id_cliente ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Mecanico (
  id_mecanico INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  especialidad VARCHAR(50 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Servicio (
  id_servicio INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  precio DECIMAL(10,2 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Repuesto (
  id_repuesto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  precio DECIMAL(10,2 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE OrdenTrabajo (
  id_orden INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  id_vehiculo INT,
  id_mecanico INT,
  fecha_inicio DATE,
  fecha_fin DATE,
  FOREIGN KEY (id_cliente ON DELETE CASCADE) REFERENCES Cliente(id_cliente ON DELETE CASCADE),
  FOREIGN KEY (id_vehiculo ON DELETE CASCADE) REFERENCES Vehiculo(id_vehiculo ON DELETE CASCADE),
  FOREIGN KEY (id_mecanico ON DELETE CASCADE) REFERENCES Mecanico(id_mecanico ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE DetalleServicio (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,
  id_orden INT,
  id_servicio INT,
  id_repuesto INT,
  cantidad INT,
  FOREIGN KEY (id_orden ON DELETE CASCADE) REFERENCES OrdenTrabajo(id_orden ON DELETE CASCADE),
  FOREIGN KEY (id_servicio ON DELETE CASCADE) REFERENCES Servicio(id_servicio ON DELETE CASCADE),
  FOREIGN KEY (id_repuesto ON DELETE CASCADE) REFERENCES Repuesto(id_repuesto ON DELETE CASCADE)
 ON DELETE CASCADE);

-- INSERTs
INSERT INTO Cliente (nombre,telefono ON DELETE CASCADE) VALUES
('Roberto Díaz','3101112222' ON DELETE CASCADE),
('Patricia Gómez','3103334444' ON DELETE CASCADE),
('Fernando Ruiz','3105556666' ON DELETE CASCADE);

INSERT INTO Vehiculo (id_cliente,placa,marca,modelo ON DELETE CASCADE) VALUES
(1,'XYZ-111','Toyota','Corolla' ON DELETE CASCADE),
(2,'ABC-222','Ford','Focus' ON DELETE CASCADE),
(3,'LMN-333','Chevrolet','Spark' ON DELETE CASCADE);

INSERT INTO Mecanico (nombre,especialidad ON DELETE CASCADE) VALUES
('Juan Torres','Motor' ON DELETE CASCADE),
('Andrés López','Suspensión' ON DELETE CASCADE),
('María Fernández','Electricidad' ON DELETE CASCADE);

INSERT INTO Servicio (nombre,precio ON DELETE CASCADE) VALUES
('Cambio de aceite',120.00 ON DELETE CASCADE),
('Alineación',80.00 ON DELETE CASCADE),
('Frenos',200.00 ON DELETE CASCADE);

INSERT INTO Repuesto (nombre,precio ON DELETE CASCADE) VALUES
('Filtro aceite',20.00 ON DELETE CASCADE),
('Pastillas freno',50.00 ON DELETE CASCADE),
('Bujía',15.00 ON DELETE CASCADE);

INSERT INTO OrdenTrabajo (id_cliente,id_vehiculo,id_mecanico,fecha_inicio,fecha_fin ON DELETE CASCADE) VALUES
(1,1,1,'2025-07-01','2025-07-02' ON DELETE CASCADE),
(2,2,2,'2025-07-05','2025-07-06' ON DELETE CASCADE),
(3,3,3,'2025-07-10','2025-07-11' ON DELETE CASCADE);

INSERT INTO DetalleServicio (id_orden,id_servicio,id_repuesto,cantidad ON DELETE CASCADE) VALUES
(1,1,1,1 ON DELETE CASCADE),
(1,2,2,1 ON DELETE CASCADE),
(2,3,2,2 ON DELETE CASCADE);

-- UPDATEs
UPDATE Vehiculo SET modelo='Corolla 2020' WHERE id_vehiculo=1;
UPDATE Servicio SET precio=130.00 WHERE id_servicio=1;
UPDATE OrdenTrabajo SET fecha_fin='2025-07-03' WHERE id_orden=1;

-- DELETEs
DELETE FROM DetalleServicio WHERE id_detalle=3;
DELETE FROM OrdenTrabajo WHERE id_orden=3;
DELETE FROM Cliente WHERE id_cliente=3;

-- SELECT simples
SELECT * FROM OrdenTrabajo;
SELECT nombre,precio FROM Servicio;
SELECT placa,marca FROM Vehiculo;

-- SELECT anidados
-- 1 ON DELETE CASCADE) COUNT( ON DELETE CASCADE) servicios por orden
SELECT o.id_orden, o.fecha_inicio,
  (SELECT COUNT(* ON DELETE CASCADE) FROM DetalleServicio d WHERE d.id_orden = o.id_orden ON DELETE CASCADE) AS total_servicios
FROM OrdenTrabajo o;

-- 2 ON DELETE CASCADE) SUM( ON DELETE CASCADE) monto aproximado de repuestos por orden (agregación ON DELETE CASCADE)
SELECT o.id_orden,
  (SELECT SUM(r.precio * d.cantidad ON DELETE CASCADE) FROM DetalleServicio d JOIN Repuesto r ON d.id_repuesto = r.id_repuesto WHERE d.id_orden = o.id_orden ON DELETE CASCADE) AS total_repuestos
FROM OrdenTrabajo o;

-- 3 ON DELETE CASCADE) LENGTH( ON DELETE CASCADE) en subconsulta (longitud del nombre del mecánico asignado ON DELETE CASCADE)
SELECT m.id_mecanico, m.nombre,
  (SELECT LENGTH(nombre ON DELETE CASCADE) FROM Mecanico mm WHERE mm.id_mecanico = m.id_mecanico ON DELETE CASCADE) AS len_nombre
FROM Mecanico m;

-- JOINS
-- INNER JOIN: detalle servicios con repuestos y servicios
SELECT d.id_detalle, s.nombre AS servicio, r.nombre AS repuesto FROM DetalleServicio d
INNER JOIN Servicio s ON d.id_servicio = s.id_servicio
INNER JOIN Repuesto r ON d.id_repuesto = r.id_repuesto;

-- LEFT JOIN: ordenes y detalles
SELECT o.id_orden, d.id_detalle FROM OrdenTrabajo o LEFT JOIN DetalleServicio d ON o.id_orden = d.id_orden;

-- RIGHT JOIN: vehiculos y ordenes (demostrativo ON DELETE CASCADE)
SELECT v.placa, o.fecha_inicio FROM Vehiculo v RIGHT JOIN OrdenTrabajo o ON v.id_vehiculo = o.id_vehiculo;
