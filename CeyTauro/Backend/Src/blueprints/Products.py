from flask import request, jsonify, render_template
from flask_cors import  cross_origin
from flask import Blueprint, request, jsonify
from blueprints.execProcedure import execute_procedure, execute_procedure_read

products_bp = Blueprint('products', __name__)

@cross_origin
@products_bp.route('/api/products_read/<int:id>', methods=['GET'])
def read_producto(id):
    try:
        result = execute_procedure_read('sp_read_producto', (id,))
        return jsonify({"message":result}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@cross_origin
@products_bp.route('/api/products_create', methods=['POST'])
def create_product():
    data = request.json
    _userAPI_rest = "apiRest_User"
    result = execute_procedure_read('sp_create_producto', (data['nombre'], data['precio'], data['unidad'],_userAPI_rest))
    return jsonify({'message': result}), 200


@cross_origin
@products_bp.route('/api/products_update', methods=['PUT'])
def products_update():
    data = request.json    
    try:
        execute_procedure('sp_update_producto', (int(data['id']), str(data['nombre']), str(data['unidad']), int(data['precio'])))
        return jsonify({'message': 'Producto actualizado exitosamente'})
    except Exception as e:
        return jsonify({'error': 'Error actualizando el producto'}), 500

@cross_origin
@products_bp.route('/api/products_delete/<int:id>', methods=['DELETE'])
def delete_producto(id):
    try:
        execute_procedure('sp_delete_producto', (id,))
        return jsonify({'message': "Producto Eliminado"})
    except Exception as e:
        return jsonify({'message': "Error Eliminando Producto Eliminado"}), 500
    

#if __name__ == '__main__':
#    app.run(debug=True)