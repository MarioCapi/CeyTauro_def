-- test para crear usuario 
DO $$
BEGIN
    CALL "management".sp_create_usuario('mario', '123456', 'correo@ejemplo.com');
END $$;


-- test para leer usuarios
DO $$
DECLARE
    resultado JSON; -- Variable para almacenar el resultado del procedimiento
BEGIN
    -- Prueba 1: Leer un usuario específico que existe
    RAISE NOTICE 'Prueba 1: Leer usuario con ID 1';
    CALL "management".sp_read_usuario(1, resultado);
    RAISE NOTICE 'Resultado: %', resultado;

    -- Prueba 2: Leer un usuario específico que no existe
    RAISE NOTICE 'Prueba 2: Leer usuario con ID inexistente (99999)';
    CALL "management".sp_read_usuario(99999, resultado);
    RAISE NOTICE 'Resultado: %', resultado;

    -- Prueba 3: Leer todos los usuarios
    RAISE NOTICE 'Prueba 3: Leer todos los usuarios';
    CALL "management".sp_read_usuario(999999999, resultado);
    RAISE NOTICE 'Resultado: %', resultado;

    -- Prueba 4: Tabla sin registros (asegúrate de probar esto con la tabla vacía)
    RAISE NOTICE 'Prueba 4: Leer todos los usuarios en una tabla vacía';
    CALL "management".sp_read_usuario(999999999, resultado);
    RAISE NOTICE 'Resultado: %', resultado;
END;
$$;

