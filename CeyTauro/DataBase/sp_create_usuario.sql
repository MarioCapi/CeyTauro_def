-- crear usuario
CREATE OR REPLACE PROCEDURE "Management".sp_create_usuario(
    p_username VARCHAR(50),
    p_password VARCHAR(100),
    p_email VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO "Management".usuarios (username, password, email)
    VALUES (p_username, p_password, p_email);
END;
$$;

-- leer usuario
CREATE OR REPLACE PROCEDURE "Management".sp_read_usuario(
    OUT p_resultado JSON,
    IN p_id_usuario INT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_id_usuario IS NOT NULL THEN
        -- Buscar y mostrar el usuario con el id especificado
        SELECT json_agg(row_to_json(t))
        INTO p_resultado
        FROM (
            SELECT 
                id_usuario, 
                username, 
                email 
            FROM "Management".usuarios
            WHERE id_usuario = p_id_usuario
        ) t;

        -- Si no se encuentra ningún usuario, devuelve un JSON vacío
        IF p_resultado IS NULL THEN
            p_resultado := '[]'::JSON;
        END IF;

    ELSE
        -- Mostrar todos los usuarios si no se proporciona id
        SELECT json_agg(row_to_json(t))
        INTO p_resultado
        FROM (
            SELECT 
                id_usuario, 
                username, 
                email 
            FROM "Management".usuarios
        ) t;

        -- Si no hay usuarios, devuelve un JSON vacío
        IF p_resultado IS NULL THEN
            p_resultado := '[]'::JSON;
        END IF;
    END IF;
END;
$$;



--actualizar usuario
CREATE OR REPLACE PROCEDURE "Management".sp_update_usuario(
    p_id_usuario INT,
    p_username VARCHAR(50),
    p_password VARCHAR(100),
    p_email VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "Management".usuarios
    SET username = p_username,
        password = p_password,
        email = p_email
    WHERE id_usuario = p_id_usuario;
END;
$$;

--eliminar usuario
CREATE OR REPLACE PROCEDURE "Management".sp_delete_usuario(
    p_id_usuario INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Intenta eliminar el usuario con el ID especificado
    DELETE FROM "Management".usuarios
    WHERE id_usuario = p_id_usuario;

    -- Verifica si la operación DELETE afectó alguna fila
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Usuario con ID % no encontrado.', p_id_usuario;
    END IF;
END;
$$;





