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
    p_id_usuario INT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_usuario INT;
    v_username VARCHAR(50);
    v_email VARCHAR(100);
BEGIN
    IF p_id_usuario IS NOT NULL THEN
        -- Buscar y mostrar el usuario con el id especificado
        SELECT id_usuario, username, email
        INTO v_id_usuario, v_username, v_email
        FROM "Management".usuarios
        WHERE id_usuario = p_id_usuario;

        -- Mostrar el resultado si se encontró el usuario
        IF v_id_usuario IS NOT NULL THEN
            RAISE NOTICE 'ID: %, Username: %, Email: %', v_id_usuario, v_username, v_email;
        ELSE
            RAISE NOTICE 'No se encontró un usuario con el ID %', p_id_usuario;
        END IF;

    ELSE
        -- Mostrar todos los usuarios si no se proporciona id
        FOR v_id_usuario, v_username, v_email IN 
            SELECT id_usuario, username, email 
            FROM "Management".usuarios
        LOOP
            RAISE NOTICE 'ID: %, Username: %, Email: %', v_id_usuario, v_username, v_email;
        END LOOP;
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
    DELETE FROM "Management".usuarios
    WHERE id_usuario = p_id_usuario;
END;
$$;




