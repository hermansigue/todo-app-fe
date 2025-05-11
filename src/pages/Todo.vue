<template>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <div class="container mt-5" style="min-height: 600px;">
    <div class="d-flex justify-content-between">
      <div class="title-page">
        <h2>Todo List</h2>
      </div>
      <div class="button-page">
        <button class="btn btn-dark mb-3" @click="showAddSwal"><i class="fas fa-plus"></i><span class="ms-2">Tambah</span></button>
        <button class="btn btn-outline-dark mb-3 ms-2" @click="showFilterSwal"><i class="fas fa-print"></i><span class="ms-2">Filter</span></button>
      </div>
    </div>

    <!-- Tabel Todo -->
    <table class="table table-hover align-middle shadow rounded overflow-hidden border">
      <thead class="bg-dark text-white">
        <tr>
          <th class="text-center" scope="col">#</th>
          <th class="w-50" scope="col">Judul</th>
          <th class="text-center" scope="col">Status</th>
          <th class="text-center" scope="col">Aksi</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(todo, index) in todos.data" :key="todo.id" class="bg-white">
          <td class="text-center fw-bold">{{ index + 1 }}</td>
          <td>{{ todo.title }}</td>
          <td class="text-center">
            <span
              :class="[
                'badge px-3 py-2',
                todo.status === 'done' ? 'bg-success' :
                todo.status === 'in_progress' ? 'bg-warning text-dark' :
                'bg-secondary'
              ]"
            >
              {{ todo.status !== null ? todo.status.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase()) : '' }}
            </span>
          </td>
          <td class="d-flex justify-content-center gap-2">
            <button v-if="todo.status !== 'done'" class="btn btn-sm btn-outline-warning d-flex align-items-center gap-1 transition" @click="showEditSwal(todo.id)">
              <i class="fas fa-pencil"></i>
              Edit
            </button>
            <button v-if="todo.status !== 'done'" class="btn btn-sm btn-outline-info d-flex align-items-center gap-1 transition" @click="showEditStatusSwal(todo.id)">
              <i class="fas fa-question"></i>
              Status
            </button>
            <button v-if="todo.status !== 'done'" class="btn btn-sm btn-outline-danger d-flex align-items-center gap-1 transition" @click="showDeleteSwal(todo.id)">
              <i class="fas fa-trash-alt"></i>
              Hapus
            </button>
            <span  v-if="todo.status === 'done'" class="badge px-3 py-2 bg-success">Todo Selesai</span>
          </td>
        </tr>
      </tbody>
    </table>

    <div v-if="meta.totalPage >= 1" class="d-flex justify-content-end mt-4">
    <nav aria-label="Page navigation">
      <ul class="pagination">
        <li class="page-item" :class="{ disabled: meta.currentPage === 1 }">
          <button class="page-link" @click="goToPage(meta.currentPage - 1)" :disabled="meta.currentPage === 1">
            Previous
          </button>
        </li>

        <li v-for="page in pageNumbers" :key="page" class="page-item" :class="{ active: meta.currentPage === page }">
          <button class="page-link" @click="goToPage(page)">
            {{ page }}
          </button>
        </li>

        <li class="page-item" :class="{ disabled: meta.currentPage === meta.totalPage }">
          <button class="page-link" @click="goToPage(meta.currentPage + 1)" :disabled="meta.currentPage === meta.totalPage">
            Next
          </button>
        </li>
      </ul>
    </nav>
  </div>
  </div>
</template>
  
<script setup>
  import { ref, onMounted, computed } from 'vue'
  import { 
    getTodos, getTodo, createTodo,
    updateTodo, updateStatusTodo, deleteTodo,
    } from '../services/api';
  import axios from 'axios'
  import Swal from 'sweetalert2'
  import toastr from 'toastr';
  import 'toastr/build/toastr.min.css';

  
  const todos = ref({ data: [], count: 0 });
  const meta = ref({
        totalRecordCount: 0,
        currentRecordCount: 0,
        totalPage: 0,
        currentPage: 0,
        perPage: 0,
        startOf: 0
    });
  const globalParams = ref({
    filters: {
      status: null,
    },
    page: 1,
  })
    
  const statusMapped = {
    'todo': { text: 'Todo'},
    'in_progress': { text: 'In Progress'},
    'done': { text: 'Done'},
  };
  
  const fetchTodos = async (params=null) => {
    const response = await getTodos(params === null ? globalParams.value: params)
    .then((res) => {
       todos.value = res.data;
       meta.value = res.data.meta;
       })
    .catch((err) => {
      toastr.error('Fetching Todo Failed' + err.message);
    });
  }

  async function showFilterSwal(){
    const { value: result } = await Swal.fire({
      title: 'Filter Todo',
      html: `
      <div class="row">
        <div class="col-12 mb-2">
          <div class="mb-3 text-start">
           <label class="mb-3"><b>Status</b></label>
           <select id="swal-input-status" name="status" class="form-select">
              <option value="">-Default-</option>
              <option value="todo">${statusMapped['todo'].text}</option>
              <option value="in_progress">${statusMapped['in_progress'].text}</option>
              <option value="done">${statusMapped['done'].text}</option>
            </select>
          </div>
        </div>
      </div>
      `,
      showCancelButton: true,
      confirmButtonText: 'Simpan',
      cancelButtonText: 'Batal',
      preConfirm: () => {
        const status = document.getElementById('swal-input-status').value
        return { status }
      },
    })

    if (result) {
      globalParams.value = {
        ...globalParams.value, 
        filters: {
          ...globalParams.value.filter, 
          status: result.status
        }
      };
      await fetchTodos(globalParams.value);
    }
  }

  async function showAddSwal() {
    const { value: title } = await Swal.fire({
      title: 'Tambah Todo',
      input: 'text',
      inputPlaceholder: 'Judul todo',
      showCancelButton: true,
      confirmButtonText: 'Simpan',
      cancelButtonText: 'Batal',
      inputValidator: (value) => {
        if (!value) {
          return 'Judul todo tidak boleh kosong!'
        }
      }
    })

    if (title) {
      console.log('Todo added:', title)
      const response = await createTodo({ title})
        .then(async (res) => {
          toastr.success(res.data.message);
          await fetchTodos();
        }).catch((err) => {
          toastr.error('Gagal menambah todo: ' + err.message);
        });
    }
  }

  async function showEditSwal(id){
    let todo;
    const response = await findTodo(id)
    .then((res) => {
      todo = res.data;
    })
    .catch((err) => {});
    if(response === null) return;

    const { value: result } = await Swal.fire({
      title: 'Edit Todo',
      html: `
      <div class="row">
        <div class="col-12 mb-2">
          <div class="mb-3 text-start">
            <label class="mb-3"><b>Judul</b></label>
            <input id="swal-input-title" class="form-control" value="${todo.title}" placeholder="Judul Todo" />
          </div>
          <div class="mb-3 text-start">
           <label class="mb-3"><b>Status</b></label>
           <select id="swal-input-isActive" name="isActive" class="form-select">
              <option value="true" ${todo.isActive ? 'selected' : ''}>Active</option>
              <option value="false" ${!todo.isActive ? 'selected' : ''}>Inactive</option>
            </select>
          </div>
        </div>
      </div>
      `,
      showCancelButton: true,
      confirmButtonText: 'Simpan',
      cancelButtonText: 'Batal',
      preConfirm: () => {
        const title = document.getElementById('swal-input-title').value
        const isActive = document.getElementById('swal-input-isActive').value
        return { title, isActive: isActive === 'true' ? true : false }
      },
    })

    if (result) {
      await updateTodo(id, result)
        .then(async (res) => {
          await fetchTodos();
          toastr.success(res.data.message);
        })
        .catch((err) => {
          toastr.error('Updating Todo Failed:' + err.message);
        });
    }
  }

  async function showEditStatusSwal(id){
    let todo;
    const response = await findTodo(id)
    .then((res) => {
      todo = res.data;
    })
    .catch((err) => {});
    if(response === null) return;

    const { value: result } = await Swal.fire({
      title: 'Edit Status Todo',
      html: `
      <div class="row">
        <div class="col-12 mb-2">
          <div class="mb-3 text-start">
           <label class="mb-3"><b>Status</b></label>
           <select id="swal-input-status" name="status" class="form-select">
              <option value="todo" ${todo.status === 'todo' ? 'selected' : ''}>${statusMapped['todo'].text}</option>
              <option value="in_progress" ${todo.status === 'in_progress' ? 'selected' : ''}>${statusMapped['in_progress'].text}</option>
              <option value="done" ${todo.status === 'done' ? 'selected' : ''}>${statusMapped['done'].text}</option>
            </select>
          </div>
        </div>
      </div>
      `,
      showCancelButton: true,
      confirmButtonText: 'Simpan',
      cancelButtonText: 'Batal',
      preConfirm: () => {
        const status = document.getElementById('swal-input-status').value
        return { status }
      },
    })

    if (result) {
      await updateStatusTodo(id, result)
        .then(async (res) => {
          await fetchTodos();
          toastr.success(res.data.message);
        })
        .catch((err) => {
          toastr.error('Updating Todo Failed:' + err.message);
        });
    }
  }
  
  async function showDeleteSwal(id){
    let todo;
    const response = await findTodo(id)
    .then((res) => {
      todo = res.data;
    })
    .catch((err) => {});
    if(response === null) return;

    const { isConfirmed } = await Swal.fire({
      title: 'Apakah Anda yakin?',
      text: 'Data yang dihapus tidak dapat dikembalikan.',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Hapus',
      cancelButtonText: 'Batal',
      reverseButtons: true
    })

    if (isConfirmed) {
      await deleteTodo(id)
        .then(async (res) => {
          await fetchTodos();
          toastr.success(res.data.message);
        })
        .catch((err) => {
          toastr.error('Deleteing Todo Failed:' + err.message);
        });
    }
  }
  
  async function findTodo(id) {
    const response = await getTodo(id)
    .then((res) => { return res.data; })
    .catch((err) => {
      toastr.error('Fetching Todo Failded' + err.message);
    });
    return response;
  }

  const pageNumbers = computed(() => {
    const pages = [];
    const totalPages = meta.value.totalPage;
    const currentPage = meta.value.currentPage;
    const delta = 2; // Mengatur seberapa banyak tombol halaman yang ditampilkan di sekitar halaman aktif

    let start = Math.max(1, currentPage - delta);
    let end = Math.min(totalPages, currentPage + delta);

    for (let i = start; i <= end; i++) {
      pages.push(i);
    }

    return pages;
  });

  async function goToPage(page){
    if (page >= 1 && page <= meta.value.totalPage) {
      meta.value.currentPage = page;
      await fetchTodos({...globalParams.value, page});
    }
  };

  
  onMounted(() => {
    fetchTodos()
  })
  </script>
  
  