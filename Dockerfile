FROM nginx:alpine

# Copy entire project folder content into /usr/share/nginx/html
COPY . /usr/share/nginx/html/

# Copy startup.sh to root and make it executable
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Optional: uncomment if you have a custom nginx.conf
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

# Use startup.sh as entrypoint to replace placeholders, then run nginx
ENTRYPOINT ["/startup.sh"]
