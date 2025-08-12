-- Script SQL para la base de datos: museo
DROP DATABASE IF EXISTS museo;
CREATE DATABASE museo CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE museo;


CREATE TABLE Visitante (
  id_visitante INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  documento VARCHAR(20 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Sala (
  id_sala INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50 ON DELETE CASCADE),
  ubicacion VARCHAR(100 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Obra (
  id_obra INT AUTO_INCREMENT PRIMARY KEY,
  id_sala INT,
  titulo VARCHAR(100 ON DELETE CASCADE),
  autor VARCHAR(100 ON DELETE CASCADE),
  FOREIGN KEY (id_sala ON DELETE CASCADE) REFERENCES Sala(id_sala ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Exposicion (
  id_exposicion INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  fecha_inicio DATE,
  fecha_fin DATE
 ON DELETE CASCADE);

CREATE TABLE Visita (
  id_visita INT AUTO_INCREMENT PRIMARY KEY,
  id_visitante INT,
  id_exposicion INT,
  fecha DATE,
  FOREIGN KEY (id_visitante ON DELETE CASCADE) REFERENCES Visitante(id_visitante ON DELETE CASCADE),
  FOREIGN KEY (id_exposicion ON DELETE CASCADE) REFERENCES Exposicion(id_exposicion ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE RegistroObra (
  id_registro INT AUTO_INCREMENT PRIMARY KEY,
  id_obra INT,
  id_exposicion INT,
  fecha_ingreso DATE,
  FOREIGN KEY (id_obra ON DELETE CASCADE) REFERENCES Obra(id_obra ON DELETE CASCADE),
  FOREIGN KEY (id_exposicion ON DELETE CASCADE) REFERENCES Exposicion(id_exposicion ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Guia (
  id_guia INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  idioma VARCHAR(50 ON DELETE CASCADE)
 ON DELETE CASCADE);

-- INSERTs
INSERT INTO Visitante (nombre,documento ON DELETE CASCADE) VALUES
('Sofía Peña','V1001' ON DELETE CASCADE),
('Alberto Ramos','V1002' ON DELETE CASCADE),
('Camila Torres','V1003' ON DELETE CASCADE);

INSERT INTO Sala (nombre,ubicacion ON DELETE CASCADE) VALUES
('Sala Principal','Planta Baja' ON DELETE CASCADE),
('Sala Moderna','Planta Alta' ON DELETE CASCADE),
('Sala Temporal','Pabellón B' ON DELETE CASCADE);

INSERT INTO Obra (id_sala,titulo,autor ON DELETE CASCADE) VALUES
(1,'La obra A','Autor A' ON DELETE CASCADE),
(2,'La obra B','Autor B' ON DELETE CASCADE),
(1,'La obra C','Autor C' ON DELETE CASCADE);

INSERT INTO Exposicion (nombre,fecha_inicio,fecha_fin ON DELETE CASCADE) VALUES
('Exposición Historia','2025-06-01','2025-09-01' ON DELETE CASCADE),
('Exposición Arte Moderno','2025-07-01','2025-10-01' ON DELETE CASCADE),
('Exposición Fotografía','2025-08-01','2025-11-01' ON DELETE CASCADE);

INSERT INTO Visita (id_visitante,id_exposicion,fecha ON DELETE CASCADE) VALUES
(1,1,'2025-08-05' ON DELETE CASCADE),
(2,2,'2025-08-06' ON DELETE CASCADE),
(3,3,'2025-08-07' ON DELETE CASCADE);

INSERT INTO RegistroObra (id_obra,id_exposicion,fecha_ingreso ON DELETE CASCADE) VALUES
(1,1,'2025-06-05' ON DELETE CASCADE),
(2,2,'2025-07-05' ON DELETE CASCADE),
(3,3,'2025-08-05' ON DELETE CASCADE);

INSERT INTO Guia (nombre,idioma ON DELETE CASCADE) VALUES
('María Gómez','Español' ON DELETE CASCADE),
('John Smith','Inglés' ON DELETE CASCADE),
('Anna Lee','Francés' ON DELETE CASCADE);

-- UPDATEs
UPDATE Obra SET autor='Autor A Modificado' WHERE id_obra=1;
UPDATE Sala SET ubicacion='Planta Baja - Ala A' WHERE id_sala=1;
UPDATE Visita SET fecha='2025-08-10' WHERE id_visita=1;

-- DELETEs
DELETE FROM RegistroObra WHERE id_registro=3;
DELETE FROM Visita WHERE id_visita=3;
DELETE FROM Visitante WHERE id_visitante=3;

-- SELECT simples
SELECT * FROM Exposicion;
SELECT titulo,autor FROM Obra;
SELECT nombre,idioma FROM Guia;

-- SELECT anidados
-- 1 ON DELETE CASCADE) COUNT( ON DELETE CASCADE) visitas por exposición
SELECT e.id_exposicion, e.nombre,
  (SELECT COUNT(* ON DELETE CASCADE) FROM Visita v WHERE v.id_exposicion = e.id_exposicion ON DELETE CASCADE) AS total_visitas
FROM Exposicion e;

-- 2 ON DELETE CASCADE) MAX( ON DELETE CASCADE) fecha_ingreso por obra en exposicion (agregación ON DELETE CASCADE)
SELECT o.id_obra, o.titulo,
  (SELECT MAX(ro.fecha_ingreso ON DELETE CASCADE) FROM RegistroObra ro WHERE ro.id_obra = o.id_obra ON DELETE CASCADE) AS ultima_fecha_ingreso
FROM Obra o;

-- 3 ON DELETE CASCADE) LENGTH( ON DELETE CASCADE) longitud del nombre de la sala
SELECT s.id_sala, s.nombre,
  (SELECT LENGTH(nombre ON DELETE CASCADE) FROM Sala ss WHERE ss.id_sala = s.id_sala ON DELETE CASCADE) AS len_nombre
FROM Sala s;

-- JOINS
-- INNER JOIN: registro obra con exposicion y obra
SELECT ro.id_registro, o.titulo AS obra, e.nombre AS exposicion FROM RegistroObra ro
INNER JOIN Obra o ON ro.id_obra = o.id_obra
INNER JOIN Exposicion e ON ro.id_exposicion = e.id_exposicion;

-- LEFT JOIN: exposiciones y visitas
SELECT e.nombre, v.fecha FROM Exposicion e LEFT JOIN Visita v ON e.id_exposicion = v.id_exposicion;

-- RIGHT JOIN: salas y obras (demostrativo ON DELETE CASCADE)
SELECT s.nombre, o.titulo FROM Sala s RIGHT JOIN Obra o ON s.id_sala = o.id_sala;
