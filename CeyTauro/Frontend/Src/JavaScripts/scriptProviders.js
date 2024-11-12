const API_URL_Read = 'http://127.0.0.1:5000/api/providers/api/providers_read';
const API_URL_Create  = 'http://127.0.0.1:5000/api/providers/providers_create';
const API_URL_Delete  = 'http://127.0.0.1:5000/api/providers/api/providers_delete';
const API_URL_Update = 'http://127.0.0.1:5000/api/providers/api/providers_update';



let providers = [];
const itemsPerPage = 20;
let currentPage = 1;

// Llamada a la API para obtener proveedores
async function fetchProviders() {
    try {
        const response = await fetch(API_URL_Read);
        if (!response.ok) {
            throw new Error(`Error en la solicitud: ${response.status}`);
        }
        const data = await response.json();
        
        // Acceder a los datos de la respuesta correctamente
        if (data.message && data.message.status === 'success') {
            providers = data.message.data || [];  // Los datos están en data.message.data
        } else {
            console.error('Error en la respuesta:', data.message ? data.message.status : 'Respuesta desconocida');
            providers = [];
        }
    } catch (error) {
        console.error('Error al obtener proveedores:', error);
        providers = [];
    }
}
// Llamada a la API para actualizar proveedores
async function updateProvider(provider) {
    try {
        const response = await fetch(API_URL_Update, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(provider),
        });
        if (response.ok) {
            const result = await response.json();
            if (result.error) {
                showError(result.error);
            } else {
                return result;                
            }
        } else {
            showError('Error al actualizar el proveedor');
        }        
    } catch (error) {
        console.error('Error en la solicitud de actualización:', error);
        showError('Error en la solicitud de actualización');
    }
}
// Llamada a la API para crear proveedores
async function createProvider(provider) {
    try {
        const response = await fetch(API_URL_Create, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(provider),  // Enviamos un solo objeto, no una lista
        });
        if (response.ok) {
            const result = await response.json();
            if (result.message) {
                alert(result.message.message);
            } else {
                return result;
            }
        } else {
            showError('Error al crear el proveedor');
        }
    } catch (error) {
        console.error('Error en la solicitud de creación:', error);
        showError('Error en la solicitud de creación');
    }
}

// Llamada a la API para eliminar proveedores
/*function deleteProvider(provider) {
    try {
        if (confirm("¿Está seguro de que desea eliminar este Proveedor?")) {
            fetch(`${API_URL_Delete}/${provider}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    alert('Error: ' + data.error);
                } else {
                    alert('Proveedor eliminado exitosamente');
                    renderProviders(); // Recargar la lista de proveedores
                }
            })
            .catch(error => console.error('Error al eliminar el Proveedor:', error));
        }
    }catch (error) {
        console.error('Error en la solicitud de eliminacion:', error);
        showError('Error en la solicitud de eliminacion');
    }
}*/

async function deleteProvider(nit_proveedor) {
    try {
        if (confirm("¿Está seguro de que desea eliminar este Proveedor?")) {
            fetch(`${API_URL_Delete}/${nit_proveedor}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                // Verificar si la respuesta fue exitosa
                if (!response.ok) {
                    throw new Error(`Error en la solicitud: ${response.statusText}`);
                }
                return response.json(); // Intentar parsear el cuerpo solo si es JSON
            })
            .then(data => {
                if (data && data.error) {
                    alert('Error: ' + data.error);
                } else {
                    alert('Proveedor eliminado exitosamente');
                    // Eliminar el proveedor de la lista local
                    providers = providers.filter(provider => provider.nit_proveedor !== nit_proveedor);                                        
                }
            })
            .catch(error => {
                console.error('Error al eliminar el Proveedor:', error);
            });
        }
    } catch (error) {
        console.error('Error en la solicitud de eliminación:', error);        
    }
    await initializeApp();
}



async function initializeApp() { 
    await fetchProviders();   
    renderProviders();
    
    
    //renderPagination();
}

 async function renderProviders(filteredProviders = providers) {
    
    const tbody = document.getElementById('productTableBody');
    tbody.innerHTML = '';
    
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const pageProviders = filteredProviders.slice(startIndex, endIndex);

    pageProviders.forEach(provider => {
        const tr = document.createElement('tr');
        tr.innerHTML = ` 
            <td>${provider.id_proveedor}</td>           
            <td>${provider.nombre_contacto}</td>
            <td>${provider.razon_social}</td>
            <td>${provider.nit_proveedor}</td>
            <td>${provider.telefono_contacto}</td>
            <td>${provider.correo_electronico}</td>
            <td>${provider.direccion}</td>
            <td>
                <button onclick="editProduct(${provider.id_proveedor})">Editar</button>
                <button class="btn delete-btn" onclick="deleteProvider(${provider.nit_proveedor})">Eliminar</button>
            </td>
        `;
        tbody.appendChild(tr);
    });
    addDeleteListeners()
    
}

function renderPagination(filteredProviders = providers) {
    const paginationDiv = document.getElementById('pagination');
    paginationDiv.innerHTML = '';
    
    const pageCount = Math.ceil(filteredProviders.length / itemsPerPage);
    
    for (let i = 1; i <= pageCount; i++) {
        const btn = document.createElement('button');
        btn.innerText = i;
        btn.classList.add('page-btn');
        if (i === currentPage) btn.classList.add('active');
        btn.onclick = () => {
            currentPage = i;
            renderProviders(filteredProviders);
            renderPagination(filteredProviders);
        };
        paginationDiv.appendChild(btn);
    }
}

document.getElementById('form').addEventListener('submit', async function(e) {
    e.preventDefault();
    const nombre = document.getElementById('providerName').value;
    const razon = document.getElementById('providerRazon').value;
    const nit = document.getElementById('ProviderNit_CC').value;
    const tel = document.getElementById('ProviderTel').value;
    const email = document.getElementById('providerEmail').value;
    const direccion = document.getElementById('providerAddress').value;

    const provider = { nit_proveedor: nit, nombre: nombre, razon: razon, telefono: tel, correo_electronico: email, direccion: direccion };

    const newProvider = await createProvider(provider);
    if (newProvider) {
        providers.push(newProvider);
    }

    this.reset();
    document.getElementById('codeproveedor').value = '';
    initializeApp();
});


/*function editProduct(id) {
    const provider = providers.find(p => p.id_proveedor == id);
    document.getElementById('codeproveedor').value = provider.id_proveedor;
    document.getElementById('providerName').value = provider.nombre_empresa;
    document.getElementById('providerRazon').value = provider.razon_social;
    document.getElementById('ProviderNit_CC').value = provider.nit_proveedor;
    document.getElementById('ProviderTel').value = provider.telefono_contacto;
    document.getElementById('providerEmail').value= provider.correo_electronico;
    document.getElementById('providerAddress').value=provider.direccion;    
}

function deleteProduct(id) {    
    if (confirm('¿Estás seguro de que deseas eliminar este proveedor?')) {        
        providers = providers.filter(p => p.codeproducto != id);        
        axios.delete(`${API_URL_Delete}/${id}`)
            .then(response => {
                console.log('proveedor Eliminado:', response.data);
                alert('proveedor eliminado exitosamente.');
            })
            .catch(error => {
                console.error('Error al eliminar el proveedor:', error);
                alert('Hubo un error al intentar eliminar el proveedor.');
            });        
        renderProviders();
        renderPagination();
    } else {        
        console.log('Eliminación de proveedor cancelada por el usuario.');
    }
}*/

document.getElementById('searchBar').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const filteredProviders = providers.filter(p => 
        p.razon_social.toLowerCase().includes(searchTerm) ||
        p.nombre_empresa.toLowerCase().includes(searchTerm) ||
        p.nit_proveedor.toString().toLowerCase().includes(searchTerm)
    );
    currentPage = 1;
    renderProviders(filteredProviders);
    //renderPagination(filteredProviders);
});

function addDeleteListeners() {
    const deleteButtons = document.querySelectorAll('.delete-btn');
    deleteButtons.forEach(button => { // Corregido: deleteButtons.forEach
        button.addEventListener('click', (e) => {
            const index = e.target.getAttribute('data-index');
            deleteProvider(index);
        });       
    });
}        

document.addEventListener('DOMContentLoaded', () => {
    initializeApp();
});


