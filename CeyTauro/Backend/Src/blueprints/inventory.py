import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)) + '/..')

from flask import Flask, request, jsonify, render_template
from flask_cors import CORS, cross_origin
from flask import Blueprint, request, jsonify
from blueprints.execProcedure import execute_procedure_read

invetory_bp = Blueprint('inventory', __name__)
app = Flask(__name__)
CORS(app)

@cross_origin
@invetory_bp.route('/api/inventory_read/<int:id>', methods=['GET'])
def read_inventory(id):
    result = execute_procedure_read('obtener_inventario', (id,))
    return jsonify({"message":result}), 200


@cross_origin
@invetory_bp.route('/api/inventory_create', methods=['POST'])
def create_inventory():
    data = request.json
    _userAPI_rest = "apiRest_User"
    result = execute_procedure_read('insertar_inventario', (data['nombre'], data['precio'], data['unidad'],_userAPI_rest))
    return jsonify({'message': result}), 200


@cross_origin
@invetory_bp.route('/api/inventory_update', methods=['PUT'])
def inventory_update():
    data = request.json    
    try:
        execute_procedure_read('actualizar_inventario', (int(data['id']), str(data['nombre']), str(data['unidad']), int(data['precio'])))
        return jsonify({'message': 'Producto actualizado exitosamente'})
    except Exception as e:
        return jsonify({'error': 'Error actualizando el producto'}), 500

@cross_origin
@invetory_bp.route('/api/inventory_delete/<int:id>', methods=['DELETE'])
def delete_inventory(id):
    try:
        execute_procedure_read('eliminar_inventario', (id,))
        return jsonify({'message': "Producto Eliminado"})
    except Exception as e:
        return jsonify({'message': "Error Eliminando Producto Eliminado"}), 500
    