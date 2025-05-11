# TODO-FE-APP

TODO-FE-APP adalah aplikasi Front End yang dibuat menggunakan Vue 3. Aplikasi ini berfungsi untuk mengintegrasikan tampilan antarmuka pengguna dengan Back End dari layanan TODO API.

## Teknologi dan Library

Aplikasi ini dibangun dengan menggunakan beberapa library dan framework berikut:

* [Vue 3](https://vuejs.org/) (`^3.5.13`) - Framework JavaScript progresif
* [Vue Router](https://router.vuejs.org/) (`^4.5.1`) - Manajemen routing halaman
* [Axios](https://axios-http.com/) (`^1.9.0`) - HTTP client untuk komunikasi dengan API
* [Bootstrap 5](https://getbootstrap.com/) (`^5.3.6`) - Framework CSS
* [SweetAlert2](https://sweetalert2.github.io/) (`^11.21.0`) - Notifikasi pop-up
* [Toastr](https://codeseven.github.io/toastr/) (`^2.1.4`) - Notifikasi toast
* [jwt-decode](https://github.com/auth0/jwt-decode) (`^4.0.0`) - Dekode token JWT

## Struktur Direktori

```
TODO-FE-APP/
├── public/                 # Berkas statis
├── src/
│   ├── assets/             # File aset seperti gambar dan style
│   ├── components/         # Komponen Vue yang dapat digunakan ulang
│   ├── pages/              # Halaman utama (route view)
│   ├── router/             # Konfigurasi vue-router
│   ├── services/           # API service seperti axios instance
│   ├── store/              # State management (opsional jika menggunakan Vuex/pinia)
│   ├── App.vue             # Root component
│   └── main.js             # Entry point aplikasi
```

## Cara Menjalankan

1. Clone repository:

```bash
git clone <url-repo>
cd TODO-FE-APP
```

2. Install dependensi:

```bash
npm install
```

3. Jalankan server pengembangan:

```bash
npm run dev
```

4. Akses aplikasi melalui browser:

```
http://localhost:5173/
```

## Halaman Aplikasi

| URL          | Akses  | Keterangan         |
| ------------ | ------ | ------------------ |
| `/login`     | Publik | Halaman login      |
| `/register`  | Publik | Halaman registrasi |
| `/dashboard` | Login  | Halaman dashboard  |
| `/todo`      | Login  | Manajemen TODO     |

## Konfigurasi Environment

Pastikan Anda sudah mengatur environment file `.env` jika dibutuhkan untuk koneksi ke TODO API.