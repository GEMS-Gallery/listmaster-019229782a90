import { backend } from 'declarations/backend';

const shoppingList = document.getElementById('shopping-list');
const addItemForm = document.getElementById('add-item-form');
const newItemInput = document.getElementById('new-item');

async function loadItems() {
    const items = await backend.getItems();
    shoppingList.innerHTML = '';
    items.forEach(item => {
        const li = document.createElement('li');
        li.innerHTML = `
            <span class="${item.completed ? 'completed' : ''}">${item.text}</span>
            <button class="toggle-btn"><i class="fas fa-check"></i></button>
            <button class="delete-btn"><i class="fas fa-trash"></i></button>
        `;
        li.dataset.id = item.id;
        shoppingList.appendChild(li);
    });
}

addItemForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const text = newItemInput.value.trim();
    if (text) {
        await backend.addItem(text);
        newItemInput.value = '';
        await loadItems();
    }
});

shoppingList.addEventListener('click', async (e) => {
    const li = e.target.closest('li');
    if (!li) return;

    const id = Number(li.dataset.id);

    if (e.target.closest('.toggle-btn')) {
        await backend.toggleItem(id);
        await loadItems();
    } else if (e.target.closest('.delete-btn')) {
        await backend.deleteItem(id);
        await loadItems();
    }
});

window.addEventListener('load', loadItems);
