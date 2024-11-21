-- Procedimiento para crear un producto
CREATE OR REPLACE PROCEDURE "Management".sp_create_producto(
    IN p_nombre_producto VARCHAR,
    IN precio NUMERIC,
    IN unidad VARCHAR,
    IN usuario_modifica VARCHAR,
    OUT mensaje TEXT
)
LANGUAGE plpgsql
AS $$
	DECLARE
    v_id_producto BIGINT;
BEGIN    
    BEGIN
        usuario_modifica := current_user;
		 INSERT INTO "Management".productos (codeProducto,nombre_producto, precio_unitario, unidad_medida)
    		VALUES ((SELECT COALESCE(MAX(id_producto) + 1, 1) FROM "Management".productos),p_nombre_producto, precio, unidad)
    		RETURNING id_producto INTO v_id_producto;
        
        mensaje := 'Producto insertado exitosamente.';
    EXCEPTION        
        WHEN OTHERS THEN
            mensaje := 'Error al insertar el producto: ' || SQLERRM;
    END;
END;
$$;




-- Procedimiento para leer un producto por ID
CREATE OR REPLACE PROCEDURE "Management".sp_read_producto(
    IN p_producto_id INT,
    OUT result JSON
)
LANGUAGE plpgsql
AS $$
DECLARE
    producto_record JSON;
BEGIN
    IF p_producto_id <> 999999999 THEN
        SELECT row_to_json(p) INTO producto_record
        FROM "Management".productos p
        WHERE code_producto = p_producto_id;

        IF producto_record IS NULL THEN
            result := json_build_object('mensaje', 'No se encontraron registros para ese ID');
        ELSE
            result := producto_record;
        END IF;
    ELSE
        SELECT json_agg(row_to_json(p)) INTO producto_record
        FROM (
            SELECT *
            FROM "Management".productos
            ORDER BY codeproducto
        ) AS p;	
        IF producto_record IS NULL OR producto_record::TEXT = '[]' THEN
            result := json_build_object('mensaje', 'No se encontraron registros.');
        ELSE
            result := producto_record;
        END IF;
    END IF;
END;
$$;







-- Procedimiento para actualizar un producto
CREATE OR REPLACE PROCEDURE "Management".sp_update_producto(
    IN p_producto_id INT,
    IN p_nombre_producto VARCHAR,
	IN p_unidad_producto VARCHAR,
	IN p_precio_producto numeric
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "Management".productos
    SET nombre_producto = p_nombre_producto,
		precio_unitario = p_precio_producto,
		unidad_medida = p_unidad_producto
    WHERE codeproducto = p_producto_id;
END;
$$;








-- Procedimiento para eliminar un producto
CREATE OR REPLACE PROCEDURE "Management".sp_delete_producto(
    IN p_producto_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_old_record RECORD;
BEGIN    
    SELECT * INTO v_old_record 
    FROM "Management".productos
    WHERE codeproducto = p_producto_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Producto con id % no encontrado.', p_producto_id;
    END IF;        
    DELETE FROM "Management".productos WHERE id_producto = p_producto_id;    
    RAISE NOTICE 'Producto con id % eliminado exitosamente.', p_producto_id;
EXCEPTION
    WHEN OTHERS THEN        
        RAISE EXCEPTION 'Error al intentar eliminar el producto con id %: %', p_producto_id, SQLERRM;
END;
$$;