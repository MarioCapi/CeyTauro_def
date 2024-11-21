from flask import Flask, request, jsonify, render_template
from flask_cors import CORS, cross_origin
from flask import Blueprint, request, jsonify
from blueprints.execProcedure import execute_procedure, execute_procedure_read
import bcrypt

usuarios_bp = Blueprint('usuarios', __name__)
app = Flask(__name__)
CORS(app)

@cross_origin
@usuarios_bp.route('/api/users_read/<int:id>', methods=['GET'])
def read_usuario(id):
    try:
        result = execute_procedure_read('sp_read_usuario', (id,))
        return jsonify({"message":result}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@cross_origin
@usuarios_bp.route('/api/users_create', methods=['POST'])
def create_usuario():
    data = request.json
    try:
        # Validar los datos recibidos
        required_fields = ['username', 'password', 'email']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({"error": f"Campo '{field}' es obligatorio"}), 400

        # Cifrar la contraseña
        salt = bcrypt.gensalt()
        hashed_password = bcrypt.hashpw(data['password'].encode('utf-8'), salt).decode('utf-8')

        # Llamar al procedimiento almacenado
        execute_procedure('sp_create_usuario', (data['username'], hashed_password, data['email']))
        return jsonify({'message': 'Usuario creado exitosamente'})
    except Exception as e:
        return jsonify({"error": f"Error al crear usuario: {str(e)}"}), 400

@cross_origin
@usuarios_bp.route('/api/update_user', methods=['PUT'])
def update_usuario():
    data = request.json
    try:
        # Validar datos recibidos
        required_fields = ['id', 'username', 'password', 'email']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({"error": f"Campo '{field}' es obligatorio"}), 400

        # Ejecutar procedimiento almacenado
        execute_procedure(
            'sp_update_usuario',
            (
                int(data['id']),
                str(data['username']),
                str(data['password']),
                str(data['email']),
            )
        )
        return jsonify({'message': 'Usuario actualizado exitosamente'})
    except Exception as e:
        return jsonify({"error": f"No se pudo actualizar el usuario: {str(e)}"}), 400

   
@cross_origin
@usuarios_bp.route('/delete_user/<int:id>', methods=['DELETE'])
def delete_usuario(id):
    try:
        execute_procedure('sp_delete_usuario', (id,))
        return jsonify({'message': 'Usuario eliminado exitosamente'}), 200
    except Exception as e:
        return jsonify({"error": f"No se pudo eliminar el usuario: {str(e)}"}), 400

    
#if __name__ == '__main__':
#    app.run(debug=True)