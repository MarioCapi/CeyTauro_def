--Crear base de datos
CREATE DATABASE "CeyTauro def";
--crear equema "Management"
CREATE SCHEMA "Management";

--crear tablas
CREATE TABLE "management".usuarios (
    id_usuario SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE "Management".productos 
(id_producto SERIAL PRIMARY KEY,
codeProducto INT NOT NULL UNIQUE,
nombre_producto VARCHAR(255) NOT NULL,
descripcion TEXT, unidad_medida VARCHAR(50),
precio_unitario DECIMAL(10, 2));

