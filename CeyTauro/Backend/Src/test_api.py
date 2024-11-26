import requests

url = "http://127.0.0.1:5000/api/ventas/api/ventas_create"
data = {
    "consecutivo_factura": 12345,
    "numero_identi_cliente": "123456789",
    "estado": "Pendiente",
    "formapago": "DEBE",
    "productos_json": [
        {"producto_id": 1, "cantidad": 91 },
        {"producto_id": 2, "cantidad": 7}
    ]
}

response = requests.post(url, json=data)
print("Status Code:", response.status_code)
print("Response JSON:", response.json())