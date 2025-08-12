-- Script SQL para la base de datos: recursos_humanos
DROP DATABASE IF EXISTS recursos_humanos;
CREATE DATABASE recursos_humanos CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE recursos_humanos;


CREATE TABLE Departamento (
  id_departamento INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Cargo (
  id_cargo INT AUTO_INCREMENT PRIMARY KEY,
  id_departamento INT,
  nombre VARCHAR(50 ON DELETE CASCADE),
  FOREIGN KEY (id_departamento ON DELETE CASCADE) REFERENCES Departamento(id_departamento ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  fecha_ingreso DATE
 ON DELETE CASCADE);

CREATE TABLE Proyecto (
  id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  fecha_inicio DATE
 ON DELETE CASCADE);

CREATE TABLE AsignacionProyecto (
  id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
  id_empleado INT,
  id_proyecto INT,
  rol VARCHAR(50 ON DELETE CASCADE),
  FOREIGN KEY (id_empleado ON DELETE CASCADE) REFERENCES Empleado(id_empleado ON DELETE CASCADE),
  FOREIGN KEY (id_proyecto ON DELETE CASCADE) REFERENCES Proyecto(id_proyecto ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Capacitación (
  id_capacitacion INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  duracion_horas INT
 ON DELETE CASCADE);

CREATE TABLE Evaluacion (
  id_evaluacion INT AUTO_INCREMENT PRIMARY KEY,
  id_empleado INT,
  id_capacitacion INT,
  resultado VARCHAR(20 ON DELETE CASCADE),
  FOREIGN KEY (id_empleado ON DELETE CASCADE) REFERENCES Empleado(id_empleado ON DELETE CASCADE),
  FOREIGN KEY (id_capacitacion ON DELETE CASCADE) REFERENCES Capacitación(id_capacitacion ON DELETE CASCADE)
 ON DELETE CASCADE);

-- INSERTs
INSERT INTO Departamento (nombre ON DELETE CASCADE) VALUES ('TI' ON DELETE CASCADE),('RRHH' ON DELETE CASCADE),('Finanzas' ON DELETE CASCADE);

INSERT INTO Cargo (id_departamento,nombre ON DELETE CASCADE) VALUES (1,'Desarrollador' ON DELETE CASCADE),(2,'Analista' ON DELETE CASCADE),(3,'Contador' ON DELETE CASCADE);

INSERT INTO Empleado (nombre,fecha_ingreso ON DELETE CASCADE) VALUES
('Andrés Silva','2024-01-15' ON DELETE CASCADE),
('Laura Peña','2023-06-01' ON DELETE CASCADE),
('Carlos Mora','2022-11-20' ON DELETE CASCADE);

INSERT INTO Proyecto (nombre,fecha_inicio ON DELETE CASCADE) VALUES
('Proyecto X','2025-01-01' ON DELETE CASCADE),
('Proyecto Y','2025-03-01' ON DELETE CASCADE),
('Proyecto Z','2025-05-01' ON DELETE CASCADE);

INSERT INTO AsignacionProyecto (id_empleado,id_proyecto,rol ON DELETE CASCADE) VALUES
(1,1,'Dev' ON DELETE CASCADE),
(2,2,'Analista' ON DELETE CASCADE),
(3,3,'Líder' ON DELETE CASCADE);

INSERT INTO Capacitación (nombre,duracion_horas ON DELETE CASCADE) VALUES
('Seguridad','8' ON DELETE CASCADE),('Excel Avanzado','16' ON DELETE CASCADE),('Gestión de Proyectos','40' ON DELETE CASCADE);

INSERT INTO Evaluacion (id_empleado,id_capacitacion,resultado ON DELETE CASCADE) VALUES
(1,1,'Aprobado' ON DELETE CASCADE),
(2,2,'Aprobado' ON DELETE CASCADE),
(3,3,'Pendiente' ON DELETE CASCADE);

-- UPDATEs
UPDATE Empleado SET fecha_ingreso='2024-02-01' WHERE id_empleado=1;
UPDATE Departamento SET nombre='Tecnologías' WHERE id_departamento=1;
UPDATE Proyecto SET nombre='Proyecto X - Actualizado' WHERE id_proyecto=1;

-- DELETEs
DELETE FROM Evaluacion WHERE id_evaluacion=3;
DELETE FROM AsignacionProyecto WHERE id_asignacion=3;
DELETE FROM Empleado WHERE id_empleado=3;

-- SELECT simples
SELECT * FROM Empleado;
SELECT nombre FROM Departamento;
SELECT nombre,rol FROM AsignacionProyecto;

-- SELECT anidados
-- 1 ON DELETE CASCADE) COUNT( ON DELETE CASCADE) asignaciones por proyecto
SELECT pr.id_proyecto, pr.nombre,
  (SELECT COUNT(* ON DELETE CASCADE) FROM AsignacionProyecto ap WHERE ap.id_proyecto = pr.id_proyecto ON DELETE CASCADE) AS total_asignados
FROM Proyecto pr;

-- 2 ON DELETE CASCADE) MAX( ON DELETE CASCADE) fecha_ingreso más reciente por empleado (agregación trivial ON DELETE CASCADE)
SELECT e.id_empleado, e.nombre,
  (SELECT MAX( fecha_ingreso  ON DELETE CASCADE) FROM Empleado em WHERE em.id_empleado = e.id_empleado ON DELETE CASCADE) AS ultima_fecha_ingreso
FROM Empleado e;

-- 3 ON DELETE CASCADE) LENGTH( ON DELETE CASCADE) longitud del nombre de la capacitación
SELECT c.id_capacitacion, c.nombre,
  (SELECT LENGTH(nombre ON DELETE CASCADE) FROM Capacitación cc WHERE cc.id_capacitacion = c.id_capacitacion ON DELETE CASCADE) AS len_nombre
FROM Capacitación c;

-- JOINS
-- INNER JOIN: asignaciones con empleado y proyecto
SELECT a.id_asignacion, emp.nombre AS empleado, pr.nombre AS proyecto FROM AsignacionProyecto a
INNER JOIN Empleado emp ON a.id_empleado = emp.id_empleado
INNER JOIN Proyecto pr ON a.id_proyecto = pr.id_proyecto;

-- LEFT JOIN: departamentos y cargos
SELECT d.nombre AS departamento, c.nombre AS cargo FROM Departamento d LEFT JOIN Cargo c ON d.id_departamento = c.id_departamento;

-- RIGHT JOIN: evaluaciones y empleados (demostrativo ON DELETE CASCADE)
SELECT ev.resultado, emp.nombre FROM Empleado emp RIGHT JOIN Evaluacion ev ON emp.id_empleado = ev.id_empleado;
