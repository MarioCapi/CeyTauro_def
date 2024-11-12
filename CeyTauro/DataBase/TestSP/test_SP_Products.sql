--Test for Users SPs
DO $$
DECLARE
    v_id int := 11;
    v_result JSON; 
BEGIN    
    CALL "Management".sp_read_producto(v_id, v_result);    
    RAISE NOTICE 'Resultado: %', v_result;
END $$;

DO $$
DECLARE
    v_id INT := 2;  
    v_result JSON;  
BEGIN    
    CALL "Management".sp_update_producto (v_id,'"CANELA ASTILLA"','Kg',2500);    
    RAISE NOTICE 'Resultado: %', v_result;
END $$;

DO $$
DECLARE
    v_result text;  
BEGIN    
    CALL "Management".sp_create_producto ('"GENERICO"',2500,'Kg','GenericUser',v_result);    
    RAISE NOTICE 'Resultado: %', v_result;
END $$;

DO $$
DECLARE
    v_id INT := 107;      
BEGIN    
    CALL "Management".sp_delete_producto (v_id);
END $$;