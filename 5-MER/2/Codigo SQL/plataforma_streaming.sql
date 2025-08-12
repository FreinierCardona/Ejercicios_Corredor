
CREATE DATABASE streaming;
USE streaming;
CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY,
    nombre VARCHAR(100),
    correo VARCHAR(100),
    contraseña VARCHAR(100)
);

CREATE TABLE Contenido (
    id_contenido INT PRIMARY KEY,
    título VARCHAR(150),
    duración TIME,
    año YEAR
);

CREATE TABLE Dispositivo (
    id_dispositivo INT PRIMARY KEY,
    tipo_dispositivo VARCHAR(50),
    marca VARCHAR(50)
);

CREATE TABLE Usuario_Contenido (
    id_usuario INT,
    id_contenido INT,
    fecha_visto DATETIME,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_contenido) REFERENCES Contenido(id_contenido)
);

CREATE TABLE Contenido_Dispositivo (
    id_contenido INT,
    id_dispositivo INT,
    FOREIGN KEY (id_contenido) REFERENCES Contenido(id_contenido),
    FOREIGN KEY (id_dispositivo) REFERENCES Dispositivo(id_dispositivo)
);

-- =====================
-- SENTENCIAS INSERT
-- =====================

INSERT INTO Usuario VALUES (1, 'Andrea López', 'andreal@example.com', 'clave1');
INSERT INTO Usuario VALUES (2, 'Mario Suárez', 'marios@example.com', 'clave2');
INSERT INTO Usuario VALUES (3, 'Lucía Torres', 'luciat@example.com', 'clave3');
INSERT INTO Usuario VALUES (4, 'Carlos Vélez', 'carlosv@example.com', 'clave4');
INSERT INTO Usuario VALUES (5, 'Nina Ríos', 'ninar@example.com', 'clave5');

-- =====================
-- SENTENCIAS TRUNCATE
-- =====================

TRUNCATE TABLE Usuario_Contenido;
TRUNCATE TABLE Contenido_Dispositivo;
TRUNCATE TABLE Dispositivo;
TRUNCATE TABLE Contenido;
TRUNCATE TABLE Usuario;

-- =====================
-- SENTENCIAS DROP
-- =====================

DROP TABLE IF EXISTS Usuario_Contenido;
DROP TABLE IF EXISTS Contenido_Dispositivo;
DROP TABLE IF EXISTS Dispositivo;
DROP TABLE IF EXISTS Contenido;
DROP TABLE IF EXISTS Usuario;

-- =====================
-- SENTENCIAS RENAME
-- =====================

RENAME TABLE Usuario TO Usuario_Renombrado;
RENAME TABLE Contenido TO Contenido_Renombrado;
RENAME TABLE Dispositivo TO Dispositivo_Renombrado;
RENAME TABLE Usuario_Contenido TO UsuCont;
RENAME TABLE Contenido_Dispositivo TO ContDisp;

-- =====================
-- SENTENCIAS UPDATE
-- =====================

UPDATE Usuario_Renombrado SET nombre = 'Ana López' WHERE id_usuario = 1;
UPDATE Usuario_Renombrado SET correo = 'nuevo@example.com' WHERE id_usuario = 2;
UPDATE Contenido_Renombrado SET título = 'Nuevo Título' WHERE id_contenido = 1;
UPDATE Dispositivo_Renombrado SET marca = 'Samsung' WHERE id_dispositivo = 1;
UPDATE Dispositivo_Renombrado SET tipo_dispositivo = 'Tablet' WHERE id_dispositivo = 2;

-- =====================
-- SENTENCIAS DELETE
-- =====================

DELETE FROM Usuario_Renombrado WHERE id_usuario = 5;
DELETE FROM Usuario_Renombrado WHERE nombre = 'Carlos Vélez';
DELETE FROM Contenido_Renombrado WHERE año < 2015;
DELETE FROM Dispositivo_Renombrado WHERE marca = 'LG';
DELETE FROM ContDisp WHERE id_dispositivo = 2;

-- =====================
-- SELECT SIMPLES
-- =====================

SELECT nombre FROM Usuario_Renombrado;

SELECT LOWER(nombre) AS nombre_minusculas FROM Usuario_Renombrado;

SELECT COUNT(*) AS total_usuarios FROM Usuario_Renombrado;

SELECT MAX(año) AS contenido_mas_reciente FROM Contenido_Renombrado;

SELECT LENGTH(título) AS longitud_titulo FROM Contenido_Renombrado;

-- =====================
-- SELECT ANIDADOS CON JOIN
-- =====================

-- INNER JOIN
SELECT U.nombre, C.título, UC.fecha_visto
FROM Usuario_Renombrado U
INNER JOIN UsuCont UC ON U.id_usuario = UC.id_usuario
INNER JOIN Contenido_Renombrado C ON UC.id_contenido = C.id_contenido;

-- LEFT JOIN
SELECT U.nombre, D.tipo_dispositivo
FROM Usuario_Renombrado U
LEFT JOIN UsuCont UC ON U.id_usuario = UC.id_usuario
LEFT JOIN ContDisp CD ON UC.id_contenido = CD.id_contenido
LEFT JOIN Dispositivo_Renombrado D ON CD.id_dispositivo = D.id_dispositivo;

-- RIGHT JOIN
SELECT D.tipo_dispositivo, C.título
FROM Dispositivo_Renombrado D
RIGHT JOIN ContDisp CD ON D.id_dispositivo = CD.id_dispositivo
RIGHT JOIN Contenido_Renombrado C ON CD.id_contenido = C.id_contenido;

-- Subconsulta: usuarios con más de un contenido visto
SELECT nombre FROM Usuario_Renombrado
WHERE id_usuario IN (
    SELECT id_usuario FROM UsuCont
    GROUP BY id_usuario
    HAVING COUNT(id_contenido) > 1
);

-- Subconsulta: contenidos vistos en 2024
SELECT título FROM Contenido_Renombrado
WHERE id_contenido IN (
    SELECT id_contenido FROM UsuCont
    WHERE YEAR(fecha_visto) = 2024
);