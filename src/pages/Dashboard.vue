<template>
  <div class="container mt-5" style="min-height: 600px;">
    <div class="row mb-5">
      <h2>Dashboard</h2>
    </div>
    <div class="row">
      <!-- Baris pertama: Card Nama -->
      <div class="col-md-6 mb-4">
        <div class="card shadow-sm rounded-lg h-100">
          <div class="card-body">
            <h5 class="card-title text-dark">Informasi Pengguna</h5>
            <p v-if="user" class="card-text">
              Nama: {{ user.name }} <br>
              Email: {{ user.email }}
            </p>
            <p v-if="!user" class="card-text">Memuat Informasi Pengguna....</p>
          </div>
        </div>
      </div>

      <!-- Baris pertama: Card Quotes -->
      <div class="col-md-6 mb-4">
        <div class="card shadow-sm rounded-lg h-100">
          <div class="card-body">
            <h5 class="card-title text-success">Quotes</h5>
            <p class="card-text" v-if="quote">{{ quote.data.quote }} -{{ quote.data.author }}</p>
            <p class="card-text" v-else>Loading quote...</p>
          </div>
        </div>
      </div>

      <!-- Baris kedua: Card Tombol ke Halaman Lain -->
      <div class="col-md-6 mb-4">
        <div class="card shadow-sm rounded-lg h-100 hover-card">
          <div class="card-body">
            <h5 class="card-title">Halaman Todo</h5>
            <router-link to="/todo" class="btn btn-dark w-100">Ke Halaman Todo</router-link>
          </div>
        </div>
      </div>

      <!-- Baris kedua: Card Tombol Logout -->
      <div class="col-md-6 mb-4">
        <div class="card shadow-sm rounded-lg h-100 hover-card">
          <div class="card-body">
            <h5 class="card-title">Keluar</h5>
            <button @click="logout" class="btn btn-danger w-100">Keluar</button>
          </div>
        </div>
      </div>
    </div>
  </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  import { jwtDecode } from 'jwt-decode';
  import { fetchQuote } from '../services/api';
  import { useRouter } from 'vue-router';
  import axios from 'axios';
  
  const quote = ref(null);
  const user = ref(null);
  const router = useRouter();

  const setUserData = (token) => {
    try {
      const decoded = jwtDecode(token)
      user.value = decoded
    } catch (error) {
      user.value = null
    }
  };

  const getQuote = async () => {
    const response = await fetchQuote()
    .then((res) => {
      quote.value = res.data;
    }).catch((err) => {
      console.error(err);
    });
  };
  
  const logout = () => {
    localStorage.removeItem('token')
    // isLoggedIn.value = false
    router.push('/login')
  }
  
  onMounted(async () => {
    const token = localStorage.getItem('token')
    // decode token
    setUserData(token);  
    await getQuote();
    
  });
  </script>

<style scoped>
  .card {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }

  .card:hover {
    transform: translateY(-10px);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  }

  .card-body {
    text-align: center;
  }

  .hover-card {
    transition: transform 0.3s ease;
  }

  .hover-card:hover {
    transform: translateY(-5px);
  }

  .card-title {
    font-weight: bold;
  }

  .card-body p {
    font-style: italic;
  }

  button {
    transition: background-color 0.3s ease;
  }

  button:hover {
    background-color: #004085;
  }
</style>

  