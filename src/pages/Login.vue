<template>
  <div class="container">
    <div class="row" style="min-height: 700px;">
      <!-- Kolom Kiri: Form Login -->
      <div class="col-md-6 p-5">
        <div class="d-flex justify-content-center align-items-center h-100">
          <div id="form-login">
            <h2 class="mb-5"><b>Masuk</b></h2>
            <form @submit.prevent="handleLogin" class="mb-3">
              <div class="mb-3">
                <label class="mb-3"><b>Email</b></label>
                <input v-model="email" type="email" class="form-control" />
              </div>
              <div class="mb-3">
                <label class="mb-3"><b>Password</b></label>
                <input v-model="password" type="password" class="form-control" />
              </div>
              <button class="btn btn-dark w-100">Login</button>
            </form>
            <small>
              Belum punya akun? <router-link to="/register" style="color: black;">Daftar di sini</router-link>
            </small>
          </div>  
        </div>      
      </div>
      <div class="col-md-6 p-0">
        <div class="w-100" style="background-image: url('/img/coffee.jpg'); background-size: cover; background-position: center; height: 100%;">
        </div>        
      </div>
    </div>
  </div>
</template>
  
<script setup>
  import { ref } from 'vue'
  import axios from 'axios'
  import { useRouter } from 'vue-router'
  import { login } from '../services/api'
  import Swal from 'sweetalert2'

  const email = ref('user1@aulia.sch.id')
  const password = ref('password')
  const router = useRouter()
  
  const handleLogin = async () => {
    const response = await login({
      email: email.value,
      password: password.value
    }).then(async (res) => {
      Swal.fire({
          title: 'Login Berhasil!',
          text: 'Selamat datang di aplikasi',
          icon: 'success',
          confirmButtonText: 'OK'
        }).then(() => {
          localStorage.setItem('token', res.data.accessToken);
          router.push('/dashboard')
        })
    }).catch(err => {
      Swal.fire({
          title: 'Gagal Login',
          text: err?.response?.data?.message || 'User Invalid',
          icon: 'error',
          confirmButtonText: 'OK'
        });
    });
  }
</script>

<style scoped>
  #form-login {
    min-width: 400px;
  }
  @media screen and (max-width: 768px) {
    #form-login {
      min-width: 300px;
    }    
  }
</style>


  