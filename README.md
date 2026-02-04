# Parking Page
Dynamic HTML to put on parking domains

## Details
You can also run it on docker compose adding it to your container, do not forget to manage ports and certificates using a reverse proxy or improving nginx service:

```
name: yourproject

services:
  git:
    image: alpine/git:latest
    container_name: yourproject-gitcloner
    volumes:
      - ./www:/www
    working_dir: /www
    entrypoint: /bin/sh -c "while true; do if [ -d .git ]; then git pull; else git clone --recurse-submodules -j8 https://github.com/ivancarlosti/parkingpage.git .; fi; sleep 600; done"
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    container_name: yourproject-nginx
    volumes:
      - ./www:/usr/share/nginx/html
    ports:
      - "80:80"
    restart: unless-stopped
    depends_on:
      - git
```

<!-- footer -->
---

## 🧑‍💻 Consulting and technical support
* For personal support and queries, please submit a new issue to have it addressed.
* For commercial related questions, please [**contact me**][ivancarlos] for consulting costs. 

| 🩷 Project support |
| :---: |
If you found this project helpful, consider [**buying me a coffee**][buymeacoffee]
|Thanks for your support, it is much appreciated!|

[ivancarlos]: https://ivancarlos.me
[buymeacoffee]: https://www.buymeacoffee.com/ivancarlos
