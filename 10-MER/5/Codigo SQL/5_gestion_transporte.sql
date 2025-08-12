-- Script SQL para la base de datos: transporte
DROP DATABASE IF EXISTS transporte;
CREATE DATABASE transporte CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE transporte;


CREATE TABLE Pasajero (
  id_pasajero INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  documento VARCHAR(20 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Ruta (
  id_ruta INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50 ON DELETE CASCADE),
  distancia_km DECIMAL(5,2 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Parada (
  id_parada INT AUTO_INCREMENT PRIMARY KEY,
  id_ruta INT,
  nombre VARCHAR(100 ON DELETE CASCADE),
  orden INT,
  FOREIGN KEY (id_ruta ON DELETE CASCADE) REFERENCES Ruta(id_ruta ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Bus (
  id_bus INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(10 ON DELETE CASCADE),
  capacidad INT
 ON DELETE CASCADE);

CREATE TABLE Conductor (
  id_conductor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  licencia VARCHAR(20 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Boleto (
  id_boleto INT AUTO_INCREMENT PRIMARY KEY,
  id_pasajero INT,
  id_ruta INT,
  fecha DATE,
  precio DECIMAL(10,2 ON DELETE CASCADE),
  FOREIGN KEY (id_pasajero ON DELETE CASCADE) REFERENCES Pasajero(id_pasajero ON DELETE CASCADE),
  FOREIGN KEY (id_ruta ON DELETE CASCADE) REFERENCES Ruta(id_ruta ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE AsignacionBus (
  id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
  id_bus INT,
  id_conductor INT,
  fecha_inicio DATE,
  fecha_fin DATE,
  FOREIGN KEY (id_bus ON DELETE CASCADE) REFERENCES Bus(id_bus ON DELETE CASCADE),
  FOREIGN KEY (id_conductor ON DELETE CASCADE) REFERENCES Conductor(id_conductor ON DELETE CASCADE)
 ON DELETE CASCADE);

-- INSERTs
INSERT INTO Pasajero (nombre,documento ON DELETE CASCADE) VALUES
('Andrés Gómez','D1001' ON DELETE CASCADE),
('Lucía Fernández','D1002' ON DELETE CASCADE),
('Diego Ramirez','D1003' ON DELETE CASCADE);

INSERT INTO Ruta (nombre,distancia_km ON DELETE CASCADE) VALUES
('Ruta A',12.50 ON DELETE CASCADE),
('Ruta B',8.75 ON DELETE CASCADE),
('Ruta C',20.00 ON DELETE CASCADE);

INSERT INTO Parada (id_ruta,nombre,orden ON DELETE CASCADE) VALUES
(1,'Parada 1',1 ON DELETE CASCADE),
(1,'Parada 2',2 ON DELETE CASCADE),
(1,'Parada 3',3 ON DELETE CASCADE);

INSERT INTO Bus (placa,capacidad ON DELETE CASCADE) VALUES
('ABC-123',40 ON DELETE CASCADE),
('DEF-456',30 ON DELETE CASCADE),
('GHI-789',50 ON DELETE CASCADE);

INSERT INTO Conductor (nombre,licencia ON DELETE CASCADE) VALUES
('Carlos Herrera','LIC-1001' ON DELETE CASCADE),
('María Ortiz','LIC-1002' ON DELETE CASCADE),
('José Rivera','LIC-1003' ON DELETE CASCADE);

INSERT INTO Boleto (id_pasajero,id_ruta,fecha,precio ON DELETE CASCADE) VALUES
(1,1,'2025-08-05',2000.00 ON DELETE CASCADE),
(2,2,'2025-08-06',1500.00 ON DELETE CASCADE),
(3,3,'2025-08-07',3000.00 ON DELETE CASCADE);

INSERT INTO AsignacionBus (id_bus,id_conductor,fecha_inicio,fecha_fin ON DELETE CASCADE) VALUES
(1,1,'2025-07-01','2025-12-31' ON DELETE CASCADE),
(2,2,'2025-07-15','2025-11-30' ON DELETE CASCADE),
(3,3,'2025-07-20','2025-10-31' ON DELETE CASCADE);

-- UPDATEs
UPDATE Boleto SET precio=2200.00 WHERE id_boleto=1;
UPDATE Bus SET capacidad=45 WHERE id_bus=1;
UPDATE Pasajero SET documento='D1001-UPDATED' WHERE id_pasajero=1;

-- DELETEs
DELETE FROM Parada WHERE id_parada=3;
DELETE FROM Boleto WHERE id_boleto=3;
DELETE FROM Pasajero WHERE id_pasajero=3;

-- SELECT simples
SELECT * FROM Ruta;
SELECT nombre,licencia FROM Conductor;
SELECT placa,capacidad FROM Bus;

-- SELECT anidados
-- 1 ON DELETE CASCADE) COUNT( ON DELETE CASCADE) boletos por ruta
SELECT r.id_ruta, r.nombre,
  (SELECT COUNT(* ON DELETE CASCADE) FROM Boleto b WHERE b.id_ruta = r.id_ruta ON DELETE CASCADE) AS total_boletos
FROM Ruta r;

-- 2 ON DELETE CASCADE) MAX( ON DELETE CASCADE) fecha de asignación por bus
SELECT b.id_bus, b.placa,
  (SELECT MAX(a.fecha_inicio ON DELETE CASCADE) FROM AsignacionBus a WHERE a.id_bus = b.id_bus ON DELETE CASCADE) AS ultima_asignacion
FROM Bus b;

-- 3 ON DELETE CASCADE) YEAR( ON DELETE CASCADE) año de la primera asignación de un bus
SELECT b.id_bus, b.placa,
  (SELECT YEAR(MIN(a.fecha_inicio ON DELETE CASCADE) ON DELETE CASCADE) FROM AsignacionBus a WHERE a.id_bus = b.id_bus ON DELETE CASCADE) AS primer_ano_asignacion
FROM Bus b;

-- JOINS
-- INNER JOIN: boletos con pasajeros y rutas
SELECT bo.id_boleto, p.nombre AS pasajero, r.nombre AS ruta FROM Boleto bo
INNER JOIN Pasajero p ON bo.id_pasajero = p.id_pasajero
INNER JOIN Ruta r ON bo.id_ruta = r.id_ruta;

-- LEFT JOIN: rutas y paradas
SELECT r.nombre AS ruta, pa.nombre AS parada FROM Ruta r LEFT JOIN Parada pa ON r.id_ruta = pa.id_ruta;

-- RIGHT JOIN: asignaciones y buses (mostrar asignaciones aunque bus nulo ON DELETE CASCADE)
SELECT a.id_asignacion, bu.placa FROM Bus bu RIGHT JOIN AsignacionBus a ON bu.id_bus = a.id_bus;
