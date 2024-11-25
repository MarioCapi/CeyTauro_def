DO $$
DECLARE
    resultado JSON;
BEGIN
    CALL management.crear_venta(
        1001, 
        '7788', 
        '[
			{"id_producto": 1, "cantidad": 2},{"id_producto": 2, "cantidad": 16},{"id_producto": 3, "cantidad": 12}
		]'::JSON,resultado
    );    
    RAISE NOTICE 'Resultado: %', resultado;
END;
$$;

