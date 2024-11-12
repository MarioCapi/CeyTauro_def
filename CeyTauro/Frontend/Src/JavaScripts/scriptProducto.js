const API_URL_Update = 'http://127.0.0.1:5000/api/products/api/products_update';
const API_URL_Read = 'http://127.0.0.1:5000/api/products/api/products_read/999999999';
const API_URL_Create  = 'http://127.0.0.1:5000/api/products/api/products_create';
const API_URL_Delete  = 'http://127.0.0.1:5000/api/products/api/products_delete';


let products = [];
const itemsPerPage = 20;
let currentPage = 1;

// Llamada a la API para obtener productos
async function fetchProducts() {
    try {
        const response = await fetch(API_URL_Read);
        if (!response.ok) {
            throw new Error(`Error en la solicitud: ${response.status}`);
        }
        const data = await response.json();
        products = data.message || [];
    } catch (error) {
        console.error('Error al obtener productos:', error);
        products = [];
    }
}

async function updateProduct(product) {
    try {
        const response = await fetch(API_URL_Update, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(product),
        });
        if (response.ok) {
            const result = await response.json();
            if (result.error) {
                showError(result.error);
            } else {
                return result;                
            }
        } else {
            showError('Error al actualizar el producto');
        }        
    } catch (error) {
        console.error('Error en la solicitud de actualización:', error);
        showError('Error en la solicitud de actualización');
    }
}

async function createProduct(product) {
    try {
        const response = await fetch(API_URL_Create, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(product),
        });
        if (response.ok) {
            const result = await response.json();
            if (result.error) {
                showError(result.error);
            } else {
                return result;
            }
        } else {
            showError('Error al crear el producto');
        }
    } catch (error) {
        console.error('Error en la solicitud de creación:', error);
        showError('Error en la solicitud de creación');
    }
}

async function initializeApp() {
    await fetchProducts();
    renderProducts(products);
    renderPagination();
}

function renderProducts(filteredProducts = products) {
    const tbody = document.getElementById('productTableBody');
    tbody.innerHTML = '';
    
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const pageProducts = filteredProducts.slice(startIndex, endIndex);

    pageProducts.forEach(product => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${product.codeproducto}</td>
            <td>${product.nombre_producto}</td>
            <td>${product.precio_unitario}</td>
            <td>${product.unidad_medida}</td>
            <td>
                <button onclick="editProduct(${product.codeproducto})">Editar</button>
                <button onclick="deleteProduct(${product.codeproducto})">Eliminar</button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function renderPagination(filteredProducts = products) {
    const paginationDiv = document.getElementById('pagination');
    paginationDiv.innerHTML = '';
    
    const pageCount = Math.ceil(filteredProducts.length / itemsPerPage);
    
    for (let i = 1; i <= pageCount; i++) {
        const btn = document.createElement('button');
        btn.innerText = i;
        btn.classList.add('page-btn');
        if (i === currentPage) btn.classList.add('active');
        btn.onclick = () => {
            currentPage = i;
            renderProducts(filteredProducts);
            renderPagination(filteredProducts);
        };
        paginationDiv.appendChild(btn);
    }
}

document.getElementById('form').addEventListener('submit', async function(e) {
    e.preventDefault();
    const id = document.getElementById('codeproducto').value;
    const nombre = document.getElementById('productName').value;
    const precio = document.getElementById('productPrice').value;
    const unidad = document.getElementById('productUnity').value;
    const product = { id, nombre, unidad, precio };
    
    if (id) {  
        const updatedProduct = await updateProduct(product);
        if(updateProduct){
            const index = products.findIndex(p => p.codeproducto == id);
            products[index] = { id, nombre, unidad, precio };
        }
    } else {  
        // Crear producto
        const product = { nombre, unidad, precio };
        const newProduct = await createProduct(product);
        if (newProduct) {
            products.push(newProduct);
        }
    }
    renderProducts();
    renderPagination();
    this.reset();
    document.getElementById('codeproducto').value = '';
    initializeApp();
});

function editProduct(id) {
    const product = products.find(p => p.codeproducto == id);    
    document.getElementById('codeproducto').value = product.codeproducto;
    document.getElementById('productName').value = product.nombre_producto;
    document.getElementById('productPrice').value = product.precio_unitario;
    document.getElementById('productUnity').value = product.unidad_medida;
}

function deleteProduct(id) {    
    if (confirm('¿Estás seguro de que deseas eliminar este producto?')) {        
        products = products.filter(p => p.codeproducto != id);        
        axios.delete(`${API_URL_Delete}/${id}`)
            .then(response => {
                console.log('Producto Eliminado:', response.data);
                alert('Producto eliminado exitosamente.');
            })
            .catch(error => {
                console.error('Error al eliminar el Producto:', error);
                alert('Hubo un error al intentar eliminar el Producto.');
            });        
        renderProducts();
        renderPagination();
    } else {        
        console.log('Eliminación de producto cancelada por el usuario.');
    }
}

document.getElementById('searchBar').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const filteredProducts = products.filter(p => 
        p.nombre_producto.toLowerCase().includes(searchTerm) ||
        p.precio_unitario.toString().toLowerCase().includes(searchTerm)
    );
    currentPage = 1;
    renderProducts(filteredProducts);
    renderPagination(filteredProducts);
});

initializeApp();
