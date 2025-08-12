-- Script SQL para la base de datos: aerolineas
DROP DATABASE IF EXISTS aerolineas;
CREATE DATABASE aerolineas CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE aerolineas;


CREATE TABLE Pasajero (
  id_pasajero INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  documento VARCHAR(20 ON DELETE CASCADE),
  nacionalidad VARCHAR(50 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Aeropuerto (
  id_aeropuerto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100 ON DELETE CASCADE),
  ciudad VARCHAR(50 ON DELETE CASCADE),
  pais VARCHAR(50 ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Avion (
  id_avion INT AUTO_INCREMENT PRIMARY KEY,
  modelo VARCHAR(50 ON DELETE CASCADE),
  capacidad INT
 ON DELETE CASCADE);

CREATE TABLE Vuelo (
  id_vuelo INT AUTO_INCREMENT PRIMARY KEY,
  id_avion INT,
  id_aeropuerto_origen INT,
  id_aeropuerto_destino INT,
  fecha_salida DATETIME,
  fecha_llegada DATETIME,
  FOREIGN KEY (id_avion ON DELETE CASCADE) REFERENCES Avion(id_avion ON DELETE CASCADE),
  FOREIGN KEY (id_aeropuerto_origen ON DELETE CASCADE) REFERENCES Aeropuerto(id_aeropuerto ON DELETE CASCADE),
  FOREIGN KEY (id_aeropuerto_destino ON DELETE CASCADE) REFERENCES Aeropuerto(id_aeropuerto ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Reserva (
  id_reserva INT AUTO_INCREMENT PRIMARY KEY,
  id_pasajero INT,
  id_vuelo INT,
  fecha_reserva DATE,
  asiento VARCHAR(5 ON DELETE CASCADE),
  FOREIGN KEY (id_pasajero ON DELETE CASCADE) REFERENCES Pasajero(id_pasajero ON DELETE CASCADE),
  FOREIGN KEY (id_vuelo ON DELETE CASCADE) REFERENCES Vuelo(id_vuelo ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Embarque (
  id_embarque INT AUTO_INCREMENT PRIMARY KEY,
  id_vuelo INT,
  id_pasajero INT,
  puerta VARCHAR(10 ON DELETE CASCADE),
  hora_embarque DATETIME,
  FOREIGN KEY (id_vuelo ON DELETE CASCADE) REFERENCES Vuelo(id_vuelo ON DELETE CASCADE),
  FOREIGN KEY (id_pasajero ON DELETE CASCADE) REFERENCES Pasajero(id_pasajero ON DELETE CASCADE)
 ON DELETE CASCADE);

CREATE TABLE Tripulacion (
  id_tripulacion INT AUTO_INCREMENT PRIMARY KEY,
  id_vuelo INT,
  piloto VARCHAR(100 ON DELETE CASCADE),
  copiloto VARCHAR(100 ON DELETE CASCADE),
  asistentes INT,
  FOREIGN KEY (id_vuelo ON DELETE CASCADE) REFERENCES Vuelo(id_vuelo ON DELETE CASCADE)
 ON DELETE CASCADE);

-- INSERTs
INSERT INTO Pasajero (nombre,documento,nacionalidad ON DELETE CASCADE) VALUES
('Juan Pérez','C12345','Colombia' ON DELETE CASCADE),
('Laura Díaz','P54321','Chile' ON DELETE CASCADE),
('Miguel Ángel','A98765','Perú' ON DELETE CASCADE);

INSERT INTO Aeropuerto (nombre,ciudad,pais ON DELETE CASCADE) VALUES
('Aeropuerto Internacional A','Bogotá','Colombia' ON DELETE CASCADE),
('Aeropuerto Internacional B','Santiago','Chile' ON DELETE CASCADE),
('Aeropuerto Internacional C','Lima','Perú' ON DELETE CASCADE);

INSERT INTO Avion (modelo,capacidad ON DELETE CASCADE) VALUES
('Boeing 737',160 ON DELETE CASCADE),
('Airbus A320',150 ON DELETE CASCADE),
('Embraer 190',100 ON DELETE CASCADE);

INSERT INTO Vuelo (id_avion,id_aeropuerto_origen,id_aeropuerto_destino,fecha_salida,fecha_llegada ON DELETE CASCADE) VALUES
(1,1,2,'2025-09-01 08:00:00','2025-09-01 11:00:00' ON DELETE CASCADE),
(2,2,3,'2025-09-02 09:00:00','2025-09-02 12:00:00' ON DELETE CASCADE),
(3,3,1,'2025-09-03 10:00:00','2025-09-03 13:00:00' ON DELETE CASCADE);

INSERT INTO Reserva (id_pasajero,id_vuelo,fecha_reserva,asiento ON DELETE CASCADE) VALUES
(1,1,'2025-08-01','12A' ON DELETE CASCADE),
(2,2,'2025-08-02','7B' ON DELETE CASCADE),
(3,3,'2025-08-03','3C' ON DELETE CASCADE);

INSERT INTO Embarque (id_vuelo,id_pasajero,puerta,hora_embarque ON DELETE CASCADE) VALUES
(1,1,'A1','2025-09-01 07:15:00' ON DELETE CASCADE),
(2,2,'B2','2025-09-02 08:30:00' ON DELETE CASCADE),
(3,3,'C3','2025-09-03 09:15:00' ON DELETE CASCADE);

INSERT INTO Tripulacion (id_vuelo,piloto,copiloto,asistentes ON DELETE CASCADE) VALUES
(1,'Piloto A','Copiloto A',4 ON DELETE CASCADE),
(2,'Piloto B','Copiloto B',3 ON DELETE CASCADE),
(3,'Piloto C','Copiloto C',5 ON DELETE CASCADE);

-- UPDATEs
UPDATE Pasajero SET telefono='300999000' WHERE id_pasajero=1; -- campo telefono no existe, demostrativo
UPDATE Vuelo SET fecha_llegada='2025-09-01 11:30:00' WHERE id_vuelo=1;
UPDATE Reserva SET asiento='14C' WHERE id_reserva=1;

-- DELETEs
DELETE FROM Embarque WHERE id_embarque=3;
DELETE FROM Reserva WHERE id_reserva=3;
DELETE FROM Pasajero WHERE id_pasajero=3;

-- SELECT simples
SELECT * FROM Vuelo;
SELECT nombre,capacidad FROM Avion;
SELECT nombre FROM Aeropuerto;

-- SELECT anidados
-- 1 ON DELETE CASCADE) agregación COUNT( ON DELETE CASCADE) para reservas por pasajero
SELECT p.id_pasajero, p.nombre,
  (SELECT COUNT(* ON DELETE CASCADE) FROM Reserva r WHERE r.id_pasajero = p.id_pasajero ON DELETE CASCADE) AS total_reservas
FROM Pasajero p;

-- 2 ON DELETE CASCADE) agregación MAX( ON DELETE CASCADE) fecha de reserva por pasajero
SELECT p.id_pasajero, p.nombre,
  (SELECT MAX(r.fecha_reserva ON DELETE CASCADE) FROM Reserva r WHERE r.id_pasajero = p.id_pasajero ON DELETE CASCADE) AS ultima_reserva
FROM Pasajero p;

-- 3 ON DELETE CASCADE) función escalar YEAR( ON DELETE CASCADE) en subconsulta para obtener año del primer vuelo asignado al avión
SELECT a.id_avion, a.modelo,
  (SELECT YEAR(MIN(v.fecha_salida ON DELETE CASCADE) ON DELETE CASCADE) FROM Vuelo v WHERE v.id_avion = a.id_avion ON DELETE CASCADE) AS primer_ano_vuelo
FROM Avion a;

-- JOINS
-- INNER JOIN: reservas con pasajeros y vuelos
SELECT r.id_reserva, p.nombre AS pasajero, v.fecha_salida AS vuelo_salida
FROM Reserva r
INNER JOIN Pasajero p ON r.id_pasajero = p.id_pasajero
INNER JOIN Vuelo v ON r.id_vuelo = v.id_vuelo;

-- LEFT JOIN: todos los vuelos y su tripulación (si existe ON DELETE CASCADE)
SELECT v.id_vuelo, v.fecha_salida, t.piloto FROM Vuelo v LEFT JOIN Tripulacion t ON v.id_vuelo = t.id_vuelo;

-- RIGHT JOIN: listar embarques y pasajeros (mostrar embarques aunque pasajero nulo ON DELETE CASCADE)
SELECT e.id_embarque, p.nombre FROM Pasajero p RIGHT JOIN Embarque e ON p.id_pasajero = e.id_pasajero;
