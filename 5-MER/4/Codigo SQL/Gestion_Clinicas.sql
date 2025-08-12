-- BASE DE DATOS: Sistema de Gestión de Clínicas
CREATE DATABASE Gestion_clinicas;
USE Gestion_clinicas;
-- =====================
-- SENTENCIAS DDL
-- =====================

CREATE TABLE Paciente (
    id_paciente INT PRIMARY KEY,
    nombre VARCHAR(100),
    edad INT,
    género VARCHAR(10)
);

CREATE TABLE Médico (
    id_medico INT PRIMARY KEY,
    nombre VARCHAR(100),
    licencia VARCHAR(50)
);

CREATE TABLE Consultorio (
    id_consultorio INT PRIMARY KEY,
    numero VARCHAR(10),
    piso INT
);

CREATE TABLE Cita (
    id_cita INT PRIMARY KEY,
    fecha DATE,
    hora TIME,
    id_consultorio INT,
    FOREIGN KEY (id_consultorio) REFERENCES Consultorio(id_consultorio)
);

CREATE TABLE Paciente_Cita (
    id_paciente INT,
    id_cita INT,
    motivo_consulta TEXT,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_cita) REFERENCES Cita(id_cita)
);

-- =====================
-- SENTENCIAS INSERT
-- =====================

INSERT INTO Paciente VALUES (1, 'Carlos Ramírez', 35, 'Masculino');
INSERT INTO Paciente VALUES (2, 'Luisa Gómez', 29, 'Femenino');
INSERT INTO Paciente VALUES (3, 'Ana Torres', 42, 'Femenino');
INSERT INTO Paciente VALUES (4, 'José Pérez', 50, 'Masculino');
INSERT INTO Paciente VALUES (5, 'Marta Rivas', 37, 'Femenino');

-- =====================
-- SENTENCIAS TRUNCATE
-- =====================

TRUNCATE TABLE Paciente_Cita;
TRUNCATE TABLE Cita;
TRUNCATE TABLE Consultorio;
TRUNCATE TABLE Médico;
TRUNCATE TABLE Paciente;

-- =====================
-- SENTENCIAS DROP
-- =====================

DROP TABLE IF EXISTS Paciente_Cita;
DROP TABLE IF EXISTS Cita;
DROP TABLE IF EXISTS Consultorio;
DROP TABLE IF EXISTS Médico;
DROP TABLE IF EXISTS Paciente;

-- =====================
-- SENTENCIAS RENAME
-- =====================

RENAME TABLE Paciente TO Paciente_Renombrado;
RENAME TABLE Cita TO Cita_Renombrada;
RENAME TABLE Médico TO Medico_Renombrado;
RENAME TABLE Paciente_Cita TO PacCita;
RENAME TABLE Consultorio TO Consultorio_Renombrado;

-- =====================
-- SENTENCIAS UPDATE
-- =====================

UPDATE Paciente_Renombrado SET edad = 36 WHERE id_paciente = 1;
UPDATE Paciente_Renombrado SET nombre = 'Luisa G.' WHERE id_paciente = 2;
UPDATE Cita_Renombrada SET hora = '09:30:00' WHERE id_cita = 1;
UPDATE Medico_Renombrado SET licencia = 'LIC2025' WHERE id_medico = 1;
UPDATE Consultorio_Renombrado SET piso = 2 WHERE id_consultorio = 1;

-- =====================
-- SENTENCIAS DELETE
-- =====================

DELETE FROM Paciente_Renombrado WHERE id_paciente = 5;
DELETE FROM Paciente_Renombrado WHERE edad > 45;
DELETE FROM Cita_Renombrada WHERE fecha < '2024-01-01';
DELETE FROM Medico_Renombrado WHERE licencia = 'ANTIGUA';
DELETE FROM PacCita WHERE id_paciente = 2;

-- =====================
-- SELECT SIMPLES
-- =====================

SELECT nombre FROM Paciente_Renombrado;

SELECT LOWER(nombre) AS nombre_minusculas FROM Paciente_Renombrado;

SELECT COUNT(*) AS total_pacientes FROM Paciente_Renombrado;

SELECT AVG(edad) AS edad_promedio FROM Paciente_Renombrado;

SELECT LENGTH(nombre) AS longitud_nombre FROM Paciente_Renombrado;

-- =====================
-- SELECT ANIDADOS CON JOIN
-- =====================

-- INNER JOIN
SELECT P.nombre, C.fecha, C.hora
FROM Paciente_Renombrado P
INNER JOIN PacCita PC ON P.id_paciente = PC.id_paciente
INNER JOIN Cita_Renombrada C ON PC.id_cita = C.id_cita;

-- LEFT JOIN
SELECT P.nombre, C.motivo_consulta
FROM Paciente_Renombrado P
LEFT JOIN PacCita C ON P.id_paciente = C.id_paciente;

-- RIGHT JOIN
SELECT C.fecha, P.nombre
FROM Cita_Renombrada C
RIGHT JOIN PacCita PC ON C.id_cita = PC.id_cita
RIGHT JOIN Paciente_Renombrado P ON PC.id_paciente = P.id_paciente;

-- Subconsulta: pacientes mayores al promedio
SELECT nombre FROM Paciente_Renombrado
WHERE edad > (
    SELECT AVG(edad) FROM Paciente_Renombrado
);

-- Subconsulta: citas del paciente 1
SELECT fecha, hora FROM Cita_Renombrada
WHERE id_cita IN (
    SELECT id_cita FROM PacCita WHERE id_paciente = 1
);
