# Parking Page

Dynamic HTML to put on parking domains

You can also run it on docker compose adding it to your container, do not forget to manage ports and certificates when needed:

```
  git:
    image: alpine/git:latest
    container_name: yourproject-gitcloner
    volumes:
      - ./www:/www
    working_dir: /www
    entrypoint: /bin/sh -c "while true; do if [ -d .git ]; then git pull; else git clone --recurse-submodules -j8 https://github.com/ivancarlosti/parkingpage.git .; fi; sleep 600; done"
    restart: unless-stopped

  php:
    image: php:apache
    container_name: yourproject-php
    depends_on:
      - git
    ports:
      - "10005:80"
    volumes:
      - ./www:/var/www/html
```
