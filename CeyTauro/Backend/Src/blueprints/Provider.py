from flask import Flask, request, jsonify, render_template
from flask_cors import CORS, cross_origin
from flask import Blueprint, request, jsonify
from blueprints.execProcedure import execute_procedure, execute_procedure_read

provider_bp = Blueprint('providers', __name__)
app = Flask(__name__)
CORS(app)


@cross_origin
@provider_bp.route('/api/providers_read', methods=['GET'])
@provider_bp.route('/api/providers_read/<int:id>', methods=['GET'])
def read_provider(id=None):
    if id is not None:
        result = execute_procedure('sp_read_proveedor', (None,id))
    else:
        result = execute_procedure_read('sp_read_proveedor', ())
    return jsonify({"message":result}), 200
    



@cross_origin
@provider_bp.route('/providers_create', methods=['POST'])  
def create_provider():
    data = request.get_json()
    try:      
        result = execute_procedure_read('sp_create_proveedor', (
            data['nit_proveedor'], data['nombre'], data['razon'], data['telefono'], data['direccion'], data['correo_electronico']))
        return jsonify({'message': result}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@cross_origin
@provider_bp.route('/api/provider_update', methods=['PUT'])
def provider_update():
    data = request.json    
    try:
        result = execute_procedure_read('sp_update_proveedor', (int(data['id']), int(data['nit']), str(data['nombre']), str(data['razon']), str(data['tel']),str(data['email']),str(data['direccion'])))
        return jsonify({'message': result}), 200
    except Exception as e:
        return jsonify({'message': result}), 500

@cross_origin
@provider_bp.route('/api/providers_delete/<string:id>', methods=['DELETE'])
def delete_provider(id):
    try:
        result = execute_procedure_read('sp_delete_proveedor',(str(id),))
        return jsonify({'message': result}), 200
    except Exception as e:
        return jsonify({'message': result}), 400



#if __name__ == '__main__':
#    app.run(debug=True)