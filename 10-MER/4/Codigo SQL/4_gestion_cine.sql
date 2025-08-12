-- Script SQL para la base de datos: cine
DROP DATABASE IF EXISTS cine;
CREATE DATABASE cine CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE cine;


CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  telefono VARCHAR(15 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Pelicula (
  id_pelicula INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(150 ON DELETE CASCADE),
  genero VARCHAR(50 ON DELETE CASCADE),
  duracion INT
 ON DELETE CASCADE);

CREATE TABLE Sala (
  id_sala INT AUTO_INCREMENT PRIMARY KEY,
  numero_sala INT,
  capacidad INT
 ON DELETE CASCADE);

CREATE TABLE Funcion (
  id_funcion INT AUTO_INCREMENT PRIMARY KEY,
  id_pelicula INT,
  id_sala INT,
  fecha_hora DATETIME,
  FOREIGN KEY (id_pelicula ON DELETE CASCADE) REFERENCES Pelicula(id_pelicula ON DELETE CASCADE),
  FOREIGN KEY (id_sala ON DELETE CASCADE) REFERENCES Sala(id_sala ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Entrada (
  id_entrada INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  id_funcion INT,
  asiento VARCHAR(5 ON DELETE CASCADE),
  precio DECIMAL(10,2 ON DELETE CASCADE),
  FOREIGN KEY (id_cliente ON DELETE CASCADE) REFERENCES Cliente(id_cliente ON DELETE CASCADE),
  FOREIGN KEY (id_funcion ON DELETE CASCADE) REFERENCES Funcion(id_funcion ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  cargo VARCHAR(50 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Snack (
  id_snack INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50 ON DELETE CASCADE),
  precio DECIMAL(10,2 ON DELETE CASCADE)
 ON DELETE CASCADE);

-- INSERTs
INSERT INTO Cliente (nombre,telefono ON DELETE CASCADE) VALUES
('Diego Alvarez','3101112222' ON DELETE CASCADE),
('Mariana Ruiz','3103334444' ON DELETE CASCADE),
('Sergio Torres','3105556666' ON DELETE CASCADE);

INSERT INTO Pelicula (titulo,genero,duracion ON DELETE CASCADE) VALUES
('La Gran Aventura','Acción',120 ON DELETE CASCADE),
('Comedia Romántica','Romance',95 ON DELETE CASCADE),
('Documental Nature','Documental',80 ON DELETE CASCADE);

INSERT INTO Sala (numero_sala,capacidad ON DELETE CASCADE) VALUES
(1,100 ON DELETE CASCADE),
(2,80 ON DELETE CASCADE),
(3,60 ON DELETE CASCADE);

INSERT INTO Funcion (id_pelicula,id_sala,fecha_hora ON DELETE CASCADE) VALUES
(1,1,'2025-08-10 18:00:00' ON DELETE CASCADE),
(2,2,'2025-08-10 20:00:00' ON DELETE CASCADE),
(3,3,'2025-08-11 16:00:00' ON DELETE CASCADE);

INSERT INTO Entrada (id_cliente,id_funcion,asiento,precio ON DELETE CASCADE) VALUES
(1,1,'A1',15000.00 ON DELETE CASCADE),
(2,2,'B2',12000.00 ON DELETE CASCADE),
(3,3,'C3',10000.00 ON DELETE CASCADE);

INSERT INTO Empleado (nombre,cargo ON DELETE CASCADE) VALUES
('Carlos Ruiz','Taquilla' ON DELETE CASCADE),
('Ana Pérez','Concesionario' ON DELETE CASCADE),
('Luis Mora','Supervisor' ON DELETE CASCADE);

INSERT INTO Snack (nombre,precio ON DELETE CASCADE) VALUES
('Popcorn','8000.00' ON DELETE CASCADE),
('Refresco','5000.00' ON DELETE CASCADE),
('Nachos','9000.00' ON DELETE CASCADE);

-- UPDATEs
UPDATE Entrada SET precio=14000.00 WHERE id_entrada=2;
UPDATE Pelicula SET duracion=125 WHERE id_pelicula=1;
UPDATE Cliente SET telefono='3100000002' WHERE id_cliente=1;

-- DELETEs
DELETE FROM Snack WHERE id_snack=3;
DELETE FROM Entrada WHERE id_entrada=3;
DELETE FROM Cliente WHERE id_cliente=3;

-- SELECT simples
SELECT * FROM Funcion;
SELECT titulo,genero FROM Pelicula;
SELECT nombre,precio FROM Snack;

-- SELECT anidados
-- 1 ON DELETE CASCADE) COUNT( ON DELETE CASCADE) entradas por función
SELECT f.id_funcion, f.fecha_hora,
  (SELECT COUNT(* ON DELETE CASCADE) FROM Entrada e WHERE e.id_funcion = f.id_funcion ON DELETE CASCADE) AS total_entradas
FROM Funcion f;

-- 2 ON DELETE CASCADE) MAX( ON DELETE CASCADE) precio de entrada por cliente (agregación en subconsulta ON DELETE CASCADE)
SELECT c.id_cliente, c.nombre,
  (SELECT MAX(e.precio ON DELETE CASCADE) FROM Entrada e WHERE e.id_cliente = c.id_cliente ON DELETE CASCADE) AS mayor_precio
FROM Cliente c;

-- 3 ON DELETE CASCADE) LENGTH( ON DELETE CASCADE) en subconsulta (longitud del título de la película ON DELETE CASCADE)
SELECT p.id_pelicula, p.titulo,
  (SELECT LENGTH(titulo ON DELETE CASCADE) FROM Pelicula pp WHERE pp.id_pelicula = p.id_pelicula ON DELETE CASCADE) AS len_titulo
FROM Pelicula p;

-- JOINS
-- INNER JOIN: entradas con clientes y funciones
SELECT e.id_entrada, c.nombre AS cliente, f.fecha_hora AS funcion FROM Entrada e
INNER JOIN Cliente c ON e.id_cliente = c.id_cliente
INNER JOIN Funcion f ON e.id_funcion = f.id_funcion;

-- LEFT JOIN: películas y funciones (si existen ON DELETE CASCADE)
SELECT p.titulo, f.fecha_hora FROM Pelicula p LEFT JOIN Funcion f ON p.id_pelicula = f.id_pelicula;

-- RIGHT JOIN: empleados y funciones atendidas (demostrativo ON DELETE CASCADE)
SELECT em.nombre, f.fecha_hora FROM Empleado em RIGHT JOIN Funcion f ON em.id_empleado = f.id_funcion;
