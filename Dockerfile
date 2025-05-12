# Tahap pertama: Build aplikasi Vue.js
FROM node:18 AS build

# Set working directory di dalam container
WORKDIR /app

# Salin file package.json dan package-lock.json (jika ada)
COPY package*.json ./

# Install dependencies
RUN npm install

# Salin seluruh kode aplikasi kecuali yang ada di .dockerignore
COPY . .

# Hapus build lama jika ada lalu build ulang
RUN rm -rf dist && npm run build

# Tahap kedua: Menyajikan aplikasi dengan Nginx
FROM nginx:alpine

# Salin hasil build dari tahap pertama ke folder yang dilayani Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 untuk aplikasi
EXPOSE 80

# Jalankan Nginx di foreground
CMD ["nginx", "-g", "daemon off;"]
