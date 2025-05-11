<template>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark text-light">
      <div class="container">
        <router-link to="/" class="navbar-brand">Vue Todo App</router-link>
        
      </div>
    </nav>
  </template>
  
  <script setup>
  import { ref } from 'vue'
  import { useRouter } from 'vue-router'
  
  const isLoggedIn = ref(localStorage.getItem('token') !== null)
  const router = useRouter()
  
  const logout = () => {
    localStorage.removeItem('token')
    isLoggedIn.value = false
    router.push('/login')
  }
  </script>
  
  <style scoped>
  /* Styling navbar */
  </style>
  