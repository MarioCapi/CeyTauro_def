--Crear base de datos
CREATE DATABASE "CeyTauro def";
--crear equema "Management"
CREATE SCHEMA "Management";

--crear tablas
CREATE TABLE "Management".usuarios (
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

CREATE TABLE management.clientes (
    id SERIAL PRIMARY KEY,
    nombre_razonsocial VARCHAR(200) NOT NULL,
    numero_identificacion VARCHAR(50) UNIQUE NOT NULL,
    correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion_envio TEXT,
    direccion_facturacion TEXT,
    fecha_creacion TIMESTAMP DEFAULT NOW()
);