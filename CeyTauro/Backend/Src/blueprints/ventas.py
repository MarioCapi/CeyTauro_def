import sys
import os
import json
sys.path.append(os.path.dirname(os.path.abspath(__file__)) + '/..')
from flask import request, jsonify
from flask_cors import cross_origin
from flask import Blueprint, request, jsonify
from blueprints.execProcedure import execute_procedure_read, execute_procedure_funct_read


ventas_bp = Blueprint('ventas', __name__)

@cross_origin
@ventas_bp.route('/api/ventas_create', methods=['POST'])
def create_ventas():
    data = request.json
    _userAPI_rest = "apiRest_User"
    try:
        productos_json_str = json.dumps(data['productos_json'])
        result = execute_procedure_read('crear_venta', (int(data['consecutivo_factura']),(data['numero_identi_cliente']),data['estado'],data['formapago'],
                                                        productos_json_str))
        return jsonify({"message":result}),200
    except Exception as e:
        return jsonify({'message': 'Error creando venta','error':str(e)}),500

@cross_origin
@ventas_bp.route('/api/ventas_read', methods=['POST'])
def read_ventas():
    try:    
        data = request.get_json() or {}
        # Alternativamente, permite parámetros en la URL como query strings
        fecha_inicio = data.get('fecha_inicio') or request.args.get('fecha_inicio')
        fecha_final = data.get('fecha_final') or request.args.get('fecha_final')
        numero_identificacion = data.get('numero_identificacion') or request.args.get('numero_identificacion')
        codeproducto = data.get('codeproducto') or request.args.get('codeproducto')
        consecutivo_factura = data.get('consecutivo_factura') or request.args.get('consecutivo_factura')
        
        params = (
            fecha_inicio,
            fecha_final,
            numero_identificacion,
            int(codeproducto) if codeproducto else None,
            int(consecutivo_factura) if consecutivo_factura else None
        )
        result = execute_procedure_funct_read('get_sales_report', params)

        return jsonify({"status": "success", "data": result}), 200
    except Exception as e:
        return jsonify({'error': 'Error al leer las ventas', 'error':str(e)}), 500

'''
@cross_origin
@ventas_bp.route('/api/inventory_update', methods=['PUT'])
def inventory_update():
    data = request.json    
    try:
        result = execute_procedure_read('actualizar_inventario', (int(data['id']),data['nombre'],int(data['cantidad']),data['unidad_medida'],data['fecha_ingreso'],
                                                                    data['proveedor'],int(data['precio_compra']),data['ubicacion'],data['notas']))        
        return jsonify({'message': 'Producto actualizado exitosamente'})
    except Exception as e:
        return jsonify({'error': 'Error actualizando el producto'}), 500
    
    
    
    

@cross_origin
@ventas_bp.route('/api/inventory_delete/<int:id>', methods=['DELETE'])
def delete_inventory(id):
    try:
        execute_procedure_read('eliminar_inventario', (id,))
        return jsonify({'message': "Producto Eliminado"})
    except Exception as e:
        return jsonify({'message': "Error Eliminando Producto Eliminado"}), 500
    
    
'''