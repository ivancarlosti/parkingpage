FROM php:8.4-fpm-alpine

# Install Nginx and MariaDB client; install PHP extensions (mysqli) and clean up
RUN apk add --no-cache --update nginx \
    && docker-php-ext-install mysqli \
    && rm -rf /var/cache/apk/* /tmp/*

# Copy your application code
COPY . /var/www/html/

# Create nginx.conf directly in the Docker build
RUN printf '%s\n' \
  'worker_processes auto;' \
  '' \
  'events { worker_connections 1024; }' \
  '' \
  'http {' \
  '    include       mime.types;' \
  '    default_type  application/octet-stream;' \
  '' \
  '    sendfile        on;' \
  '' \
  '    server {' \
  '        listen       80;' \
  '        server_name  localhost;' \
  '        root   /var/www/html;' \
  '' \
  '        index  index.php index.html;' \
  '' \
  '        location / {' \
  '            try_files $uri $uri/ /index.php?$query_string;' \
  '        }' \
  '' \
  '        location ~ \.php$ {' \
  '            include fastcgi_params;' \
  '            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' \
  '            fastcgi_index index.php;' \
  '            fastcgi_pass 127.0.0.1:9000;' \
  '        }' \
  '    }' \
  '}' \
  > /etc/nginx/nginx.conf

# Make sure Nginx and PHP-FPM can access/serve project files
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD php-fpm -D && nginx -g 'daemon off;'
