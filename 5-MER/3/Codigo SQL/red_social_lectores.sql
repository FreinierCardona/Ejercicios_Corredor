-- BASE DE DATOS: Red Social para Lectores
CREATE DATABASE redSocial_lectores;
USE redSocial_lectores;
-- =====================
-- SENTENCIAS DDL
-- =====================

CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY,
    nombre VARCHAR(100),
    correo VARCHAR(100)
);

CREATE TABLE Autor (
    id_autor INT PRIMARY KEY,
    nombre VARCHAR(100),
    nacionalidad VARCHAR(50)
);

CREATE TABLE Libro (
    id_libro INT PRIMARY KEY,
    título VARCHAR(150),
    año_publicacion YEAR,
    id_autor INT,
    FOREIGN KEY (id_autor) REFERENCES Autor(id_autor)
);

CREATE TABLE Género (
    id_genero INT PRIMARY KEY,
    nombre_genero VARCHAR(100)
);

CREATE TABLE Usuario_Libro (
    id_usuario INT,
    id_libro INT,
    fecha_lectura DATE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);

-- =====================
-- SENTENCIAS INSERT
-- =====================

INSERT INTO Usuario VALUES (1, 'Luis Fernández', 'luisf@mail.com');
INSERT INTO Usuario VALUES (2, 'Ana Pineda', 'anap@mail.com');
INSERT INTO Usuario VALUES (3, 'Carlos Méndez', 'carlosm@mail.com');
INSERT INTO Usuario VALUES (4, 'Sandra López', 'sandral@mail.com');
INSERT INTO Usuario VALUES (5, 'Pablo Gaitán', 'pablog@mail.com');

-- =====================
-- SENTENCIAS TRUNCATE
-- =====================

TRUNCATE TABLE Usuario_Libro;
TRUNCATE TABLE Género;
TRUNCATE TABLE Libro;
TRUNCATE TABLE Autor;
TRUNCATE TABLE Usuario;

-- =====================
-- SENTENCIAS DROP
-- =====================

DROP TABLE IF EXISTS Usuario_Libro;
DROP TABLE IF EXISTS Género;
DROP TABLE IF EXISTS Libro;
DROP TABLE IF EXISTS Autor;
DROP TABLE IF EXISTS Usuario;

-- =====================
-- SENTENCIAS RENAME
-- =====================

RENAME TABLE Usuario TO Usuario_Renombrado;
RENAME TABLE Libro TO Libro_Renombrado;
RENAME TABLE Autor TO Autor_Renombrado;
RENAME TABLE Usuario_Libro TO UsuLibro;
RENAME TABLE Género TO Genero_Renombrado;

-- =====================
-- SENTENCIAS UPDATE
-- =====================

UPDATE Usuario_Renombrado SET nombre = 'Luis F.' WHERE id_usuario = 1;
UPDATE Usuario_Renombrado SET correo = 'nuevo@mail.com' WHERE id_usuario = 2;
UPDATE Libro_Renombrado SET título = 'Nuevo Libro' WHERE id_libro = 1;
UPDATE Autor_Renombrado SET nacionalidad = 'Argentina' WHERE id_autor = 1;
UPDATE Genero_Renombrado SET nombre_genero = 'Fantasía' WHERE id_genero = 1;

-- =====================
-- SENTENCIAS DELETE
-- =====================

DELETE FROM Usuario_Renombrado WHERE id_usuario = 5;
DELETE FROM Usuario_Renombrado WHERE nombre = 'Carlos Méndez';
DELETE FROM Libro_Renombrado WHERE año_publicacion < 2000;
DELETE FROM Autor_Renombrado WHERE nacionalidad = 'Francia';
DELETE FROM UsuLibro WHERE id_libro = 3;

-- =====================
-- SELECT SIMPLES
-- =====================

SELECT nombre FROM Usuario_Renombrado;

SELECT UPPER(nombre) AS nombre_mayuscula FROM Usuario_Renombrado;

SELECT COUNT(*) AS total_usuarios FROM Usuario_Renombrado;

SELECT AVG(YEAR(CURDATE()) - año_publicacion) AS edad_promedio_libros FROM Libro_Renombrado;

SELECT LENGTH(título) AS longitud_titulo FROM Libro_Renombrado;

-- =====================
-- SELECT ANIDADOS CON JOIN
-- =====================

-- INNER JOIN
SELECT U.nombre, L.título, UL.fecha_lectura
FROM Usuario_Renombrado U
INNER JOIN UsuLibro UL ON U.id_usuario = UL.id_usuario
INNER JOIN Libro_Renombrado L ON UL.id_libro = L.id_libro;

-- LEFT JOIN
SELECT L.título, A.nombre
FROM Libro_Renombrado L
LEFT JOIN Autor_Renombrado A ON L.id_autor = A.id_autor;

-- RIGHT JOIN
SELECT A.nombre, L.título
FROM Autor_Renombrado A
RIGHT JOIN Libro_Renombrado L ON A.id_autor = L.id_autor;

-- Subconsulta: Usuarios que han leído más de 1 libro
SELECT nombre FROM Usuario_Renombrado
WHERE id_usuario IN (
    SELECT id_usuario FROM UsuLibro
    GROUP BY id_usuario
    HAVING COUNT(id_libro) > 1
);

-- Subconsulta: Libros leídos en 2025
SELECT título FROM Libro_Renombrado
WHERE id_libro IN (
    SELECT id_libro FROM UsuLibro WHERE YEAR(fecha_lectura) = 2025
);
