-- Script SQL para la base de datos: parque_diversiones
DROP DATABASE IF EXISTS parque_diversiones;
CREATE DATABASE parque_diversiones CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE parque_diversiones;


CREATE TABLE Visitante (
  id_visitante INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  documento VARCHAR(20 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Atraccion (
  id_atraccion INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  tipo VARCHAR(50 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  cargo VARCHAR(50 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Tienda (
  id_tienda INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  ubicacion VARCHAR(50 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  id_tienda INT,
  nombre VARCHAR(100 ON DELETE CASCADE),
  precio DECIMAL(10,2 ON DELETE CASCADE),
  FOREIGN KEY (id_tienda ON DELETE CASCADE) REFERENCES Tienda(id_tienda ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Entrada (
  id_entrada INT AUTO_INCREMENT PRIMARY KEY,
  id_visitante INT,
  fecha DATE,
  precio DECIMAL(10,2 ON DELETE CASCADE),
  FOREIGN KEY (id_visitante ON DELETE CASCADE) REFERENCES Visitante(id_visitante ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE UsoAtraccion (
  id_uso INT AUTO_INCREMENT PRIMARY KEY,
  id_visitante INT,
  id_atraccion INT,
  hora_inicio DATETIME,
  hora_fin DATETIME,
  FOREIGN KEY (id_visitante ON DELETE CASCADE) REFERENCES Visitante(id_visitante ON DELETE CASCADE),
  FOREIGN KEY (id_atraccion ON DELETE CASCADE) REFERENCES Atraccion(id_atraccion ON DELETE CASCADE)
 ON DELETE CASCADE);

-- INSERTs
INSERT INTO Visitante (nombre,documento ON DELETE CASCADE) VALUES
('Pedro Luna','V2001' ON DELETE CASCADE),
('Sofia Martínez','V2002' ON DELETE CASCADE),
('Diego Salcedo','V2003' ON DELETE CASCADE);

INSERT INTO Atraccion (nombre,tipo ON DELETE CASCADE) VALUES
('Montaña Rusa','Emoción' ON DELETE CASCADE),
('Carrusel','Familiar' ON DELETE CASCADE),
('Casa del Terror','Suspenso' ON DELETE CASCADE);

INSERT INTO Empleado (nombre,cargo ON DELETE CASCADE) VALUES
('Julián Rojas','Operador' ON DELETE CASCADE),
('Carla Vega','Taquilla' ON DELETE CASCADE),
('Oscar Ruiz','Seguridad' ON DELETE CASCADE);

INSERT INTO Tienda (nombre,ubicacion ON DELETE CASCADE) VALUES
('Tienda Central','Zona A' ON DELETE CASCADE),
('Tienda Infantil','Zona B' ON DELETE CASCADE),
('Souvenirs','Zona C' ON DELETE CASCADE);

INSERT INTO Producto (id_tienda,nombre,precio ON DELETE CASCADE) VALUES
(1,'Camiseta',35000.00 ON DELETE CASCADE),
(1,'Gorra',15000.00 ON DELETE CASCADE),
(2,'Muñeco',25000.00 ON DELETE CASCADE);

INSERT INTO Entrada (id_visitante,fecha,precio ON DELETE CASCADE) VALUES
(1,'2025-08-10',90000.00 ON DELETE CASCADE),
(2,'2025-08-11',80000.00 ON DELETE CASCADE),
(3,'2025-08-12',70000.00 ON DELETE CASCADE);

INSERT INTO UsoAtraccion (id_visitante,id_atraccion,hora_inicio,hora_fin ON DELETE CASCADE) VALUES
(1,1,'2025-08-10 10:00:00','2025-08-10 10:05:00' ON DELETE CASCADE),
(2,2,'2025-08-11 11:00:00','2025-08-11 11:05:00' ON DELETE CASCADE),
(3,3,'2025-08-12 12:00:00','2025-08-12 12:10:00' ON DELETE CASCADE);

-- UPDATEs
UPDATE Entrada SET precio=85000.00 WHERE id_entrada=2;
UPDATE Producto SET precio=16000.00 WHERE id_producto=2;
UPDATE Visitante SET documento='V2001-UPDATED' WHERE id_visitante=1;

-- DELETEs
DELETE FROM Producto WHERE id_producto=3;
DELETE FROM UsoAtraccion WHERE id_uso=3;
DELETE FROM Visitante WHERE id_visitante=3;

-- SELECT simples
SELECT * FROM Atraccion;
SELECT nombre,precio FROM Producto;
SELECT * FROM Tienda;

-- SELECT anidados
-- 1 ON DELETE CASCADE) COUNT( ON DELETE CASCADE) usos por atracción
SELECT a.id_atraccion, a.nombre,
  (SELECT COUNT(* ON DELETE CASCADE) FROM UsoAtraccion ua WHERE ua.id_atraccion = a.id_atraccion ON DELETE CASCADE) AS total_usos
FROM Atraccion a;

-- 2 ON DELETE CASCADE) MAX( ON DELETE CASCADE) precio de entrada (agregación ON DELETE CASCADE)
SELECT v.id_visitante, v.nombre,
  (SELECT MAX(e.precio ON DELETE CASCADE) FROM Entrada e WHERE e.id_visitante = v.id_visitante ON DELETE CASCADE) AS mayor_precio_entrada
FROM Visitante v;

-- 3 ON DELETE CASCADE) LENGTH( ON DELETE CASCADE) longitud del nombre de la tienda
SELECT t.id_tienda, t.nombre,
  (SELECT LENGTH(nombre ON DELETE CASCADE) FROM Tienda tt WHERE tt.id_tienda = t.id_tienda ON DELETE CASCADE) AS len_nombre
FROM Tienda t;

-- JOINS
-- INNER JOIN: uso atraccion con visitante y atraccion
SELECT ua.id_uso, vis.nombre AS visitante, at.nombre AS atraccion FROM UsoAtraccion ua
INNER JOIN Visitante vis ON ua.id_visitante = vis.id_visitante
INNER JOIN Atraccion at ON ua.id_atraccion = at.id_atraccion;

-- LEFT JOIN: tiendas y productos
SELECT ti.nombre AS tienda, pr.nombre AS producto FROM Tienda ti LEFT JOIN Producto pr ON ti.id_tienda = pr.id_tienda;

-- RIGHT JOIN: entradas y visitantes (demostrativo ON DELETE CASCADE)
SELECT en.id_entrada, vi.nombre FROM Visitante vi RIGHT JOIN Entrada en ON vi.id_visitante = en.id_visitante;
