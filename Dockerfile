FROM nginx:alpine

# Copy entire project folder content into /usr/share/nginx/html
COPY . /usr/share/nginx/html/

# Copy startup.sh to root and make it executable
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Create a minimal nginx.conf with access restriction for /startup.sh inline
RUN printf '%s\n' \
  'worker_processes auto;' \
  '' \
  'events { worker_connections 1024; }' \
  '' \
  'http {' \
  '    include       mime.types;' \
  '    default_type  application/octet-stream;' \
  '    sendfile        on;' \
  '' \
  '    server {' \
  '        listen       80;' \
  '        server_name  localhost;' \
  '        root   /usr/share/nginx/html;' \
  '        index  index.html index.htm;' \
  '' \
  '        location = /startup.sh {' \
  '            deny all;' \
  '            return 403;' \
  '        }' \
  '' \
  '        location / {' \
  '            try_files $uri $uri/ =404;' \
  '        }' \
  '    }' \
  '}' \
  > /etc/nginx/nginx.conf

EXPOSE 80

# Use startup.sh as entrypoint to replace placeholders, then run nginx
ENTRYPOINT ["/startup.sh"]
