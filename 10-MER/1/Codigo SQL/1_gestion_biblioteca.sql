-- Script SQL para la base de datos: biblioteca
DROP DATABASE IF EXISTS biblioteca;
CREATE DATABASE biblioteca CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE biblioteca;


-- Tablas
CREATE TABLE Autor (
  id_autor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE) NOT NULL,
  nacionalidad VARCHAR(50 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Editorial (
  id_editorial INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE) NOT NULL,
  direccion VARCHAR(150 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50 ON DELETE CASCADE) NOT NULL,
  descripcion TEXT
 ON DELETE CASCADE);

CREATE TABLE Libro (
  id_libro INT AUTO_INCREMENT PRIMARY KEY,
  id_categoria INT,
  id_autor INT,
  titulo VARCHAR(150 ON DELETE CASCADE) NOT NULL,
  isbn VARCHAR(20 ON DELETE CASCADE),
  año_publicacion YEAR,
  FOREIGN KEY (id_categoria ON DELETE CASCADE) REFERENCES Categoria(id_categoria ON DELETE CASCADE),
  FOREIGN KEY (id_autor ON DELETE CASCADE) REFERENCES Autor(id_autor ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE) NOT NULL,
  direccion VARCHAR(150 ON DELETE CASCADE),
  telefono VARCHAR(15 ON DELETE CASCADE),
  email VARCHAR(100 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Prestamo (
  id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT,
  id_libro INT,
  fecha_prestamo DATE,
  fecha_devolucion DATE,
  FOREIGN KEY (id_usuario ON DELETE CASCADE) REFERENCES Usuario(id_usuario ON DELETE CASCADE),
  FOREIGN KEY (id_libro ON DELETE CASCADE) REFERENCES Libro(id_libro ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Multa (
  id_multa INT AUTO_INCREMENT PRIMARY KEY,
  id_prestamo INT,
  monto DECIMAL(10,2 ON DELETE CASCADE),
  fecha_pago DATE,
  FOREIGN KEY (id_prestamo ON DELETE CASCADE) REFERENCES Prestamo(id_prestamo ON DELETE CASCADE)
 ON DELETE CASCADE);

-- INSERTs (mínimo 3 por entidad ON DELETE CASCADE)
INSERT INTO Autor (nombre,nacionalidad ON DELETE CASCADE) VALUES
('Gabriel García Márquez','Colombia' ON DELETE CASCADE),
('Isabel Allende','Chile' ON DELETE CASCADE),
('J.K. Rowling','Reino Unido' ON DELETE CASCADE);

INSERT INTO Editorial (nombre,direccion ON DELETE CASCADE) VALUES
('Editorial Alfa','Calle 1 #10-10' ON DELETE CASCADE),
('Editorial Beta','Calle 2 #20-20' ON DELETE CASCADE),
('Editorial Gamma','Calle 3 #30-30' ON DELETE CASCADE);

INSERT INTO Categoria (nombre,descripcion ON DELETE CASCADE) VALUES
('Novela','Narrativa extensa' ON DELETE CASCADE),
('Ciencia','Libros de divulgación científica' ON DELETE CASCADE),
('Infantil','Libros para niños' ON DELETE CASCADE);

INSERT INTO Libro (id_categoria,id_autor,titulo,isbn,año_publicacion ON DELETE CASCADE) VALUES
(1,1,'Cien años de soledad','978-1234567890',1967 ON DELETE CASCADE),
(2,2,'La casa de los espíritus','978-2345678901',1982 ON DELETE CASCADE),
(3,3,'Harry Potter y la piedra filosofal','978-3456789012',1997 ON DELETE CASCADE);

INSERT INTO Usuario (nombre,direccion,telefono,email ON DELETE CASCADE) VALUES
('Carlos Pérez','Cll 5 #10-10','3001112222','carlos@example.com' ON DELETE CASCADE),
('María López','Cll 6 #11-11','3003334444','maria@example.com' ON DELETE CASCADE),
('Ana Gómez','Cll 7 #12-12','3005556666','ana@example.com' ON DELETE CASCADE);

INSERT INTO Prestamo (id_usuario,id_libro,fecha_prestamo,fecha_devolucion ON DELETE CASCADE) VALUES
(1,1,'2025-07-01','2025-07-15' ON DELETE CASCADE),
(2,2,'2025-07-05','2025-07-19' ON DELETE CASCADE),
(3,3,'2025-07-10','2025-07-24' ON DELETE CASCADE);

INSERT INTO Multa (id_prestamo,monto,fecha_pago ON DELETE CASCADE) VALUES
(1,5.00,'2025-07-20' ON DELETE CASCADE),
(2,0.00,NULL ON DELETE CASCADE),
(3,10.00,'2025-08-01' ON DELETE CASCADE);

-- 3 UPDATEs
UPDATE Usuario SET telefono='3000000001' WHERE id_usuario=1;
UPDATE Libro SET precio=NULL WHERE id_libro=2; -- campo precio no existe, demostrativo (si da error, omitir ON DELETE CASCADE)
UPDATE Prestamo SET fecha_devolucion='2025-07-18' WHERE id_prestamo=2;

-- 3 DELETEs (eliminaciones demostrativas ON DELETE CASCADE)
DELETE FROM Multa WHERE id_multa=2;
DELETE FROM Prestamo WHERE id_prestamo=3;
DELETE FROM Usuario WHERE id_usuario=3;

-- 3 SELECT simples
SELECT * FROM Usuario;
SELECT titulo, isbn, año_publicacion FROM Libro;
SELECT nombre FROM Autor;

-- 3 SELECT anidados (cada subconsulta usa una función de agregación o escalar ON DELETE CASCADE)
-- 1 ON DELETE CASCADE) subconsulta con agregación COUNT( ON DELETE CASCADE)
SELECT u.id_usuario, u.nombre,
  (SELECT COUNT(* ON DELETE CASCADE) FROM Prestamo p WHERE p.id_usuario = u.id_usuario ON DELETE CASCADE) AS total_prestamos
FROM Usuario u;

-- 2 ON DELETE CASCADE) subconsulta con función escalar YEAR( ON DELETE CASCADE) sobre MAX(fecha_prestamo ON DELETE CASCADE)
SELECT l.id_libro, l.titulo,
  (SELECT YEAR(MAX(p.fecha_prestamo ON DELETE CASCADE) ON DELETE CASCADE) FROM Prestamo p WHERE p.id_libro = l.id_libro ON DELETE CASCADE) AS ultimo_ano_prestamo
FROM Libro l;

-- 3 ON DELETE CASCADE) subconsulta con función escalar LENGTH( ON DELETE CASCADE)
SELECT a.id_autor, a.nombre,
  (SELECT LENGTH(nombre ON DELETE CASCADE) FROM Autor au WHERE au.id_autor = a.id_autor ON DELETE CASCADE) AS longitud_nombre
FROM Autor a;

-- JOINs
-- INNER JOIN: listar préstamos con usuario y libro
SELECT p.id_prestamo, u.nombre AS usuario, l.titulo AS libro
FROM Prestamo p
INNER JOIN Usuario u ON p.id_usuario = u.id_usuario
INNER JOIN Libro l ON p.id_libro = l.id_libro;

-- LEFT JOIN: todos los libros y sus préstamos (si los hay ON DELETE CASCADE)
SELECT l.titulo, p.fecha_prestamo
FROM Libro l
LEFT JOIN Prestamo p ON l.id_libro = p.id_libro;

-- RIGHT JOIN: todos los préstamos y sus multas (si las hay ON DELETE CASCADE) - MySQL soporta RIGHT JOIN
SELECT p.id_prestamo, m.monto, m.fecha_pago
FROM Multa m
RIGHT JOIN Prestamo p ON m.id_prestamo = p.id_prestamo;

-- Nota: algunos UPDATE/DELETE mostrados son demostrativos; ajusta según tus reglas de integridad.
