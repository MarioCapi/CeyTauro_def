DO $$
DECLARE
    v_result JSON;  
BEGIN    
    CALL management.sp_insert_product('002','nomProd','kg','generic_prod',8900,v_result);    
    RAISE NOTICE 'Resultado: %', v_result;
END $$;


--Test for Users SPs

DO $$
DECLARE
    v_result JSON;  
BEGIN    
    CALL management.sp_read_producto(v_result);    
    RAISE NOTICE 'Resultado: %', v_result;
END $$;




DO $$
DECLARE
	v_id varchar := '001';  
    v_result JSON;  
BEGIN    
    CALL management.sp_delete_producto(v_id,v_result);    
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


