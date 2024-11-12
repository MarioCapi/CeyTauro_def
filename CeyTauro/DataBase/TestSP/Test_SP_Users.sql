-- test para crear usuario 
DO $$
BEGIN
    CALL "Management".sp_create_usuario('mario', '123456', 'correo@ejemplo.com');
END $$;


-- test para leer usuarios
DO $$
BEGIN
    -- Llamada al procedimiento para buscar un usuario específico por ID
    RAISE NOTICE '--- Buscando usuario con ID 1 ---';
    CALL "Management".sp_read_usuario(1);  -- Cambia el 1 por el id que deseas buscar

    -- Llamada al procedimiento sin parámetro para mostrar todos los usuarios
    RAISE NOTICE '--- Mostrando todos los usuarios ---';
    CALL "Management".sp_read_usuario();   -- Llama sin argumento para obtener todos
END $$;

-- test para actualizar usuario
DO $$
BEGIN
    CALL "Management".sp_update_usuario(1, 'alonso', '999999', 'nuevo_correo@ejemplo.com');
END $$;

-- test para eliminar un usuario
DO $$
BEGIN
    CALL "Management".sp_delete_usuario(1);
END $$;