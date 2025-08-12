
USE gestion_escolar;
CREATE TABLE Estudiante (
    id_estudiante INT PRIMARY KEY,
    nombre VARCHAR(100),
    edad INT,
    correo VARCHAR(100)
);

CREATE TABLE Curso (
    id_curso INT PRIMARY KEY,
    nombre_curso VARCHAR(100),
    fecha_inicio DATE
);

CREATE TABLE Profesor (
    id_profesor INT PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(100)
);

CREATE TABLE Asignatura (
    id_asignatura INT PRIMARY KEY,
    nombre_asignatura VARCHAR(100),
    intensidad_horaria INT
);

CREATE TABLE Estudiante_Curso (
    id_estudiante INT,
    id_curso INT,
    FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id_estudiante),
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso)
);

-- =====================
-- SENTENCIAS INSERT
-- =====================

INSERT INTO Estudiante VALUES (1, 'Carlos Gómez', 17, 'carlosg@gmail.com');
INSERT INTO Estudiante VALUES (2, 'Laura Pérez', 19, 'laurap@hotmail.com');
INSERT INTO Estudiante VALUES (3, 'Juan Díaz', 20, 'juand@gmail.com');
INSERT INTO Estudiante VALUES (4, 'Marta Ruiz', 18, 'martar@outlook.com');
INSERT INTO Estudiante VALUES (5, 'Pedro Torres', 21, 'pedrot@yahoo.com');

-- =====================
-- SENTENCIAS TRUNCATE
-- =====================

TRUNCATE TABLE Estudiante_Curso;
TRUNCATE TABLE Asignatura;
TRUNCATE TABLE Profesor;
TRUNCATE TABLE Curso;
TRUNCATE TABLE Estudiante;

-- =====================
-- SENTENCIAS DROP
-- =====================

DROP TABLE IF EXISTS Estudiante_Curso;
DROP TABLE IF EXISTS Asignatura;
DROP TABLE IF EXISTS Profesor;
DROP TABLE IF EXISTS Curso;
DROP TABLE IF EXISTS Estudiante;

-- =====================
-- SENTENCIAS RENAME
-- =====================

RENAME TABLE Curso TO Curso_Renombrado;
RENAME TABLE Profesor TO Profesor_Renombrado;
RENAME TABLE Estudiante TO Estudiante_Renombrado;
RENAME TABLE Asignatura TO Asignatura_Renombrada;
RENAME TABLE Estudiante_Curso TO EstCurso;

-- =====================
-- SENTENCIAS UPDATE
-- =====================

UPDATE Estudiante_Renombrado SET edad = 18 WHERE id_estudiante = 1;
UPDATE Estudiante_Renombrado SET correo = 'nuevo@email.com' WHERE id_estudiante = 2;
UPDATE Curso_Renombrado SET nombre_curso = 'Matemáticas' WHERE id_curso = 1;
UPDATE Profesor_Renombrado SET especialidad = 'Física' WHERE id_profesor = 1;
UPDATE Asignatura_Renombrada SET intensidad_horaria = 6 WHERE id_asignatura = 1;

-- =====================
-- SENTENCIAS DELETE
-- =====================

DELETE FROM Estudiante_Renombrado WHERE id_estudiante = 5;
DELETE FROM Estudiante_Renombrado WHERE edad > 20;
DELETE FROM Curso_Renombrado WHERE nombre_curso = 'Historia';
DELETE FROM Profesor_Renombrado WHERE nombre = 'Laura Gómez';
DELETE FROM Asignatura_Renombrada WHERE intensidad_horaria < 2;

-- =====================
-- SELECT SIMPLES
-- =====================

SELECT nombre FROM Estudiante_Renombrado;

SELECT UPPER(nombre) AS nombre_mayuscula FROM Estudiante_Renombrado;

SELECT COUNT(*) AS total_estudiantes FROM Estudiante_Renombrado;

SELECT AVG(edad) AS edad_promedio FROM Estudiante_Renombrado;

SELECT LENGTH(nombre_curso) AS longitud_nombre FROM Curso_Renombrado;

-- =====================
-- SELECT ANIDADOS CON JOIN
-- =====================

-- INNER JOIN
SELECT E.nombre, C.nombre_curso
FROM Estudiante_Renombrado E
INNER JOIN EstCurso EC ON E.id_estudiante = EC.id_estudiante
INNER JOIN Curso_Renombrado C ON EC.id_curso = C.id_curso;

-- LEFT JOIN
SELECT E.nombre, C.nombre_curso
FROM Estudiante_Renombrado E
LEFT JOIN EstCurso EC ON E.id_estudiante = EC.id_estudiante
LEFT JOIN Curso_Renombrado C ON EC.id_curso = C.id_curso;

-- RIGHT JOIN
SELECT E.nombre, C.nombre_curso
FROM Estudiante_Renombrado E
RIGHT JOIN EstCurso EC ON E.id_estudiante = EC.id_estudiante
RIGHT JOIN Curso_Renombrado C ON EC.id_curso = C.id_curso;

-- Subconsulta: Estudiantes mayores al promedio
SELECT nombre, edad
FROM Estudiante_Renombrado
WHERE edad > (
    SELECT AVG(edad) FROM Estudiante_Renombrado
);

-- Subconsulta: Cursos de un estudiante específico
SELECT nombre_curso
FROM Curso_Renombrado
WHERE id_curso IN (
    SELECT id_curso FROM EstCurso WHERE id_estudiante = 2
);
