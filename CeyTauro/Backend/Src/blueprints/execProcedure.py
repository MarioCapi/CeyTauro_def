import os
import sys
import psycopg2
from  psycopg2 import OperationalError
from psycopg2.extras import RealDictCursor


sys.path.append(os.path.dirname(os.path.dirname(__file__)))
print(os.path.dirname(os.path.dirname(__file__)))
from config.configDb import *
config_file = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'config', 'data.ini')

def execute_procedure(proc_name, params=None):    
    parameters = get_db_config(config_file)
    try:
        with psycopg2.connect(**parameters) as conn:            
            #with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            with conn.cursor() as cursor:
                if params:                    
                    param_placeholders = ','.join(['%s'] * len(params))
                    cursor.execute(f'CALL "Management"."{proc_name}"({param_placeholders})', params)
                else:
                     cursor.execute(f'CALL "Management"."{proc_name}"()')

                result = cursor.fetchone()[0] if cursor.description else None                
        conn.commit()
        return result
    except Exception as e:
        conn.rollback()
        raise e
    finally:
        cursor.close()
        conn.close()

def execute_procedure_read(proc_name, params=None):    
    parameters = get_db_config(config_file)
    try:
        with psycopg2.connect(**parameters) as conn:
            with conn.cursor() as cursor:
                if params:
                    param_placeholders = ','.join(['%s'] * len(params)) + ', %s'
                    cursor.execute(f'CALL "Management"."{proc_name}"({param_placeholders})', (*params, None))
                else:
                    cursor.execute(f'CALL "Management"."{proc_name}"(%s)', (None,))                    

                result = cursor.fetchone()[0] if cursor.description else None
                
        conn.commit()
        return result
    except Exception as e:
        conn.rollback()
        raise e
    finally:
        cursor.close()
        conn.close()