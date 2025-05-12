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

# Tambahkan konfigurasi Nginx untuk fallback ke index.html
RUN echo 'server {' > /etc/nginx/conf.d/default.conf && \
    echo '  listen 80;' >> /etc/nginx/conf.d/default.conf && \
    echo '  server_name localhost;' >> /etc/nginx/conf.d/default.conf && \
    echo '  root /usr/share/nginx/html;' >> /etc/nginx/conf.d/default.conf && \
    echo '  index index.html;' >> /etc/nginx/conf.d/default.conf && \
    echo '  location / {' >> /etc/nginx/conf.d/default.conf && \
    echo '    try_files $uri $uri/ /index.html;' >> /etc/nginx/conf.d/default.conf && \
    echo '  }' >> /etc/nginx/conf.d/default.conf && \
    echo '  error_page 404 /index.html;' >> /etc/nginx/conf.d/default.conf && \
    echo '}' >> /etc/nginx/conf.d/default.conf

# Expose port 80 untuk aplikasi
EXPOSE 80

# Jalankan Nginx di foreground
CMD ["nginx", "-g", "daemon off;"]
