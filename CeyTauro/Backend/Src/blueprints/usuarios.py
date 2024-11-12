from flask import Flask, request, jsonify, render_template
from flask_cors import CORS, cross_origin
from flask import Blueprint, request, jsonify
from blueprints.execProcedure import execute_procedure, execute_procedure_read

usuarios_bp = Blueprint('usuarios', __name__)
app = Flask(__name__)
CORS(app)
    
##@cross_origin
##@usuarios_bp.route('/api/users_read/<int:id>', methods=['GET'])
##def read_usuario(id=None):    
    ##try:
        ##if id is not None:          
           ## result = execute_procedure('sp_read_usuario', (None,id))
       ## else:
      ##      result = execute_procedure_read('sp_read_usuario', ())
        ##return jsonify({"message":result}), 200
   ## except Exception as e:
      ##  return jsonify({"error": str(e)}), 400   
    
@cross_origin
@usuarios_bp.route('/api/users_read/', methods=['GET'])
@usuarios_bp.route('/api/users_read/<int:id>', methods=['GET'])
def read_usuario(id=None):    
    try:
        if id is not None:          
            # Pasa 'None' para p_resultado, que será llenado en el procedimiento
            result = execute_procedure('sp_read_usuario', (None, id))
        else:
            # Si no se pasa el id, se pasa 'None' para usar el valor por defecto
            result = execute_procedure_read('sp_read_usuario', ())
        
        # El resultado es un JSON, así que lo retornamos
        return jsonify({"message": result}), 200
    
    except Exception as e:
        return jsonify({"error": str(e)}), 400




@cross_origin
@usuarios_bp.route('/api/users_create', methods=['POST'])
def create_usuario():
    data = request.json
    try:
        _userAPI_rest = "apiRest_User"
        execute_procedure('sp_create_usuario', (data['username'], data['password'], data['email']))
        return jsonify({'message': 'Usuario creado exitosamente'})
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@cross_origin
@usuarios_bp.route('/api/update_user', methods=['PUT'])
def update_usuario():
    data = request.json
    try:
        _userAPI_rest = "apiRest_User"    
        execute_procedure('sp_update_usuario', (int(data['id']), str(data['fullName']), str(data['password']), str(data['email'])))
        return jsonify({'message': 'Usuario actualizado exitosamente'})
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@cross_origin
@usuarios_bp.route('/api/delete_user/<int:id>', methods=['DELETE'])
def delete_usuario(id):
    try:
        execute_procedure('sp_delete_usuario', (id,))
        return jsonify({'message': 'Usuario eliminado exitosamente'})
    except Exception as e:
        return jsonify({"error": str(e)}), 400
    
#if __name__ == '__main__':
#    app.run(debug=True)