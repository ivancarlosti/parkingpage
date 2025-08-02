FROM nginx:alpine

# Copy your static website files (HTML, CSS, JS, images, etc.) into Nginx html directory
COPY . /usr/share/nginx/html

# Optional: If you have a custom nginx.conf, copy it here. 
# Otherwise, default nginx config serves static files correctly.
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
