<template>
    <div class="container">
      <div class="row" style="min-height: 700px;">
        <div class="col-md-6 p-5">
          <div class="d-flex justify-content-center align-items-center h-100">
            <div id="form-register">
              <h2 class="mb-5"><b>Registrasi</b></h2>
              <form @submit.prevent="handleRegister" class="mb-3">
                <div class="mb-3">
                  <label class="mb-3"><b>Email</b></label>
                  <input v-model="email" type="email" placeholder="Silahkan isi email" class="form-control"  />
                </div>
                <div class="mb-3">
                  <label class="mb-3"><b>Nama</b></label>
                  <input v-model="name" type="text" placeholder="Silahkan isi nama"  class="form-control"  />
                </div>
                <div class="mb-3">
                  <label class="mb-3"><b>Password</b></label>
                  <input v-model="password" type="password" placeholder="Silahkan isi password" class="form-control" />
                </div>
                <div class="mb-3">
                  <label class="mb-3"><b>Konfirmasi Password</b></label>
                  <input v-model="confirmationPassword" type="password" placeholder="Silahkan isi konfirmasi password" class="form-control"  />
                </div>
                <button class="btn btn-dark w-100">Registrasi</button>
              </form>
              <small>
                Sudah punya akun? <router-link to="/login" style="color: black;">Masuk di sini</router-link>
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
  
  const email = ref('')
  const name = ref('')
  const password = ref('');
  const confirmationPassword = ref('');
  const dto = [email, name, password, confirmationPassword];
  const router = useRouter();
  import { register } from '../services/api'
  import Swal from 'sweetalert2'
  
  const handleRegister = async () => {
    const isValid = !dto.some((item) => {
      if (item.value === '' || item.value == null) {
        console.log(item);
        console.log(`${item} tidak boleh kosong`);
        return true;
      }
      return false;
    });

    if(isValid){
      const response = await register({
        email: email.value,
        name: name.value,
        password: password.value,
        confirmationPassword: confirmationPassword.value,
      }).then(res => {
        Swal.fire({
            title: 'Registrasi Berhasil!',
            text: 'Selamat datang di aplikasi',
            icon: 'success',
            confirmButtonText: 'OK'
          }).then(() => {
            localStorage.setItem('token', res.data.accessToken)
            router.push('/dashboard')
          })

      }).catch(err => {
        console.log(err.response);
        Swal.fire({
            title: 'Gagal Registrasi',
            text: err?.response?.data?.message || 'User Invalid',
            icon: 'error',
            confirmButtonText: 'OK'
          });
      });
    }
  }
  </script>
  
  <style>
  #form-register {
    min-width: 400px;
  }
  @media screen and (max-width: 768px) {
    #form-register {
      min-width: 300px;
    }    
  }</style>