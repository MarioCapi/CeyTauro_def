-- test para crear usuario 
DO $$
BEGIN
    CALL "Management".sp_create_usuario('mario', '123456', 'correo@ejemplo.com');
END $$;


-- test para leer usuarios
DO $$
DECLARE
    resultado JSON; -- Variable para almacenar el resultado del procedimiento
BEGIN
    -- Prueba 1: Leer un usuario específico que existe
    RAISE NOTICE 'Prueba 1: Leer usuario con ID 1';
    CALL "Management".sp_read_usuario(resultado, 1);
    RAISE NOTICE 'Resultado: %', resultado;

    -- Prueba 2: Leer un usuario específico que no existe
    RAISE NOTICE 'Prueba 2: Leer usuario con ID inexistente (ID 99999)';
    CALL "Management".sp_read_usuario(resultado, 99999);
    RAISE NOTICE 'Resultado: %', resultado;

    -- Prueba 3: Leer todos los usuarios
    RAISE NOTICE 'Prueba 3: Leer todos los usuarios';
    CALL "Management".sp_read_usuario(resultado, NULL);
    RAISE NOTICE 'Resultado: %', resultado;
END;
$$;
