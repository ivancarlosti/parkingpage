# Parking Page

Dynamic HTML to put on parking domains

You can also run it on docker compose adding it to your container:

```
  nginx:
    image: nginx:alpine
    container_name: yourproject-nginx
    volumes:
      - ./www:/usr/share/nginx/html
    ports:
      - "10000:80"
    restart: unless-stopped
    depends_on:
      - git

  git:
    image: alpine/git:latest
    container_name: yourproject-gitcloner
    volumes:
      - ./www:/www
    working_dir: /www
    entrypoint: /bin/sh -c "while true; do if [ -d .git ]; then git pull; else git clone --recurse-submodules -j8 https://github.com/ivancarlosti/parkingpage.git .; fi; sleep 1800; done"
    restart: unless-stopped
```
