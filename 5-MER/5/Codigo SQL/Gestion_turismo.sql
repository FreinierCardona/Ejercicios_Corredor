-- BASE DE DATOS: Plataforma de Turismo y Reservas
CREATE DATABASE turismo;
USE turismo;
-- ================
-- DDL - CREATE
-- ================

CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE Guia (
    id_guia INT PRIMARY KEY,
    nombre VARCHAR(100),
    idioma VARCHAR(50)
);

CREATE TABLE PaqueteTuristico (
    id_paquete INT PRIMARY KEY,
    nombre VARCHAR(100),
    duracion INT,
    id_guia INT,
    FOREIGN KEY (id_guia) REFERENCES Guia(id_guia)
);

CREATE TABLE Reserva (
    id_reserva INT PRIMARY KEY,
    fecha DATE,
    cantidad_personas INT,
    id_usuario INT,
    id_paquete INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_paquete) REFERENCES PaqueteTuristico(id_paquete)
);

CREATE TABLE Reseña (
    id_reseña INT PRIMARY KEY,
    comentario TEXT,
    puntuacion DECIMAL(2,1),
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Preferencia (
    id_preferencia INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Usuario_Preferencia (
    id_usuario INT,
    id_preferencia INT,
    PRIMARY KEY (id_usuario, id_preferencia),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_preferencia) REFERENCES Preferencia(id_preferencia)
);

CREATE TABLE Tour_Reserva (
    id_reserva INT,
    id_paquete INT,
    PRIMARY KEY (id_reserva, id_paquete),
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
    FOREIGN KEY (id_paquete) REFERENCES PaqueteTuristico(id_paquete)
);

-- ================
-- DML - INSERT
-- ================

INSERT INTO Usuario VALUES (1, 'Camila Vargas', 'camila@example.com');
INSERT INTO Usuario VALUES (2, 'Juan Méndez', 'juan@example.com');
INSERT INTO Usuario VALUES (3, 'Laura Ríos', 'laura@example.com');
INSERT INTO Usuario VALUES (4, 'Pedro Suárez', 'pedro@example.com');
INSERT INTO Usuario VALUES (5, 'Valentina Mora', 'valentina@example.com');

-- ================
-- TRUNCATE
-- ================

TRUNCATE TABLE Reseña;
TRUNCATE TABLE Reserva;
TRUNCATE TABLE PaqueteTuristico;
TRUNCATE TABLE Guia;
TRUNCATE TABLE Usuario;

-- ================
-- DROP
-- ================

DROP TABLE IF EXISTS Tour_Reserva;
DROP TABLE IF EXISTS Usuario_Preferencia;
DROP TABLE IF EXISTS Preferencia;
DROP TABLE IF EXISTS Reseña;
DROP TABLE IF EXISTS Reserva;

-- ================
-- RENAME
-- ================

RENAME TABLE Usuario TO Usuario_Renombrado;
RENAME TABLE Guia TO Guia_Renombrado;
RENAME TABLE PaqueteTuristico TO Paquete_Renombrado;
RENAME TABLE Reserva TO Reserva_Renombrado;
RENAME TABLE Reseña TO Resena_Renombrada;

-- ================
-- UPDATE
-- ================

UPDATE Usuario_Renombrado SET nombre = 'Camila V.' WHERE id_usuario = 1;
UPDATE Usuario_Renombrado SET email = 'juanm@example.com' WHERE id_usuario = 2;
UPDATE Guia_Renombrado SET idioma = 'Portugués' WHERE id_guia = 1;
UPDATE Paquete_Renombrado SET duracion = 10 WHERE id_paquete = 1;
UPDATE Reserva_Renombrado SET cantidad_personas = 5 WHERE id_reserva = 1;

-- ================
-- DELETE
-- ================

DELETE FROM Usuario_Renombrado WHERE id_usuario = 5;
DELETE FROM Usuario_Renombrado WHERE nombre LIKE '%Pedro%';
DELETE FROM Paquete_Renombrado WHERE duracion < 3;
DELETE FROM Reserva_Renombrado WHERE cantidad_personas > 6;
DELETE FROM Resena_Renombrada WHERE puntuacion < 3.0;

-- ================
-- SELECT simples con funciones
-- ================

SELECT COUNT(*) AS total_usuarios FROM Usuario_Renombrado;
SELECT AVG(puntuacion) AS promedio_calificacion FROM Resena_Renombrada;
SELECT UPPER(nombre) AS nombre_mayuscula FROM Usuario_Renombrado;
SELECT LENGTH(email) AS longitud_email FROM Usuario_Renombrado;
SELECT NOW() AS fecha_consulta;

-- ================
-- SELECT con JOIN
-- ================

-- INNER JOIN
SELECT U.nombre, R.fecha
FROM Usuario_Renombrado U
INNER JOIN Reserva_Renombrado R ON U.id_usuario = R.id_usuario;

-- LEFT JOIN
SELECT G.nombre, P.nombre
FROM Guia_Renombrado G
LEFT JOIN Paquete_Renombrado P ON G.id_guia = P.id_guia;

-- RIGHT JOIN
SELECT P.nombre, R.cantidad_personas
FROM Paquete_Renombrado P
RIGHT JOIN Reserva_Renombrado R ON P.id_paquete = R.id_paquete;

-- Subconsulta 1: Usuarios con más de una reserva
SELECT nombre FROM Usuario_Renombrado
WHERE id_usuario IN (
    SELECT id_usuario FROM Reserva_Renombrado
    GROUP BY id_usuario HAVING COUNT(*) > 1
);

-- Subconsulta 2: Paquetes con duración mayor al promedio
SELECT nombre FROM Paquete_Renombrado
WHERE duracion > (
    SELECT AVG(duracion) FROM Paquete_Renombrado
);
