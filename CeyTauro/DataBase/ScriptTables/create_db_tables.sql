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
