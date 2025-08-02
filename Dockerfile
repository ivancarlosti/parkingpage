FROM nginx:alpine

# Copy your static website files (HTML, CSS, JS, images, etc.) into Nginx html directory
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Optional: If you have a custom nginx.conf, copy it here. 
# Otherwise, default nginx config serves static files correctly.
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
