<template>
  <div>
    <!-- Navbar -->
    <Navbar />
    <!-- Halaman lainnya -->
    <router-view />
    <!-- Footer -->
    <div class="container-fluid bg-dark text-light border-top border-light">
      <div class="d-flex justify-content-center align-items-center p-2">
        <small class="mb-0">Testing Page</small>
      </div>
    </div>

  </div>
</template>

<script setup>
import Navbar from './components/Navbar.vue'
</script>

<style>
/* Styling global */
</style>

