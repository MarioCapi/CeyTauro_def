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

-- Table: management.inventario-- DROP TABLE IF EXISTS management.inventario;
CREATE TABLE IF NOT EXISTS management.inventario
(
    id integer NOT NULL DEFAULT nextval('management.inventario_id_seq'::regclass),
    nombre_especia character varying(50) COLLATE pg_catalog."default" NOT NULL,
    cantidad integer NOT NULL,
    unidad_medida character varying(50) COLLATE pg_catalog."default" NOT NULL,
    fecha_ingreso date NOT NULL,
    proveedor character varying(100) COLLATE pg_catalog."default",
    precio_compra numeric(10,2),
    ubicacion character varying(100) COLLATE pg_catalog."default",
    notas text COLLATE pg_catalog."default",
    CONSTRAINT inventario_pkey PRIMARY KEY (id)
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS management.inventario
    OWNER to postgres;




CREATE TABLE management.ventas (
    id_venta 			SERIAL PRIMARY KEY, 
	consecutivo_factura	bigint NOT NULL,
    id_cliente 			INT NOT NULL,
    id_producto 		INT NOT NULL,
    cantidad 			INT NOT NULL CHECK (cantidad > 0),
	total 				DECIMAL(15, 2),
    fecha_venta TIMESTAMP DEFAULT NOW(),
	
    
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) 
        REFERENCES management.clientes (id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_producto FOREIGN KEY (id_producto) 
        REFERENCES management.productos (id_producto) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);


