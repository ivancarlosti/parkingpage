# Parking Page
Dynamic HTML to put on parking domains

<!-- buttons -->
[![Stars](https://img.shields.io/github/stars/ivancarlosti/parkingpage?label=⭐%20Stars&color=gold&style=flat)](https://github.com/ivancarlosti/parkingpage/stargazers)
[![Watchers](https://img.shields.io/github/watchers/ivancarlosti/parkingpage?label=Watchers&style=flat&color=red)](https://github.com/sponsors/ivancarlosti)
[![Forks](https://img.shields.io/github/forks/ivancarlosti/parkingpage?label=Forks&style=flat&color=ff69b4)](https://github.com/sponsors/ivancarlosti)
[![Downloads](https://img.shields.io/github/downloads/ivancarlosti/parkingpage/total?label=Downloads&color=success)](https://github.com/ivancarlosti/parkingpage/releases)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/ivancarlosti/parkingpage?label=Activity)](https://github.com/ivancarlosti/parkingpage/pulse)  
[![GitHub Issues](https://img.shields.io/github/issues/ivancarlosti/parkingpage?label=Issues&color=orange)](https://github.com/ivancarlosti/parkingpage/issues)
[![License](https://img.shields.io/github/license/ivancarlosti/parkingpage?label=License)](LICENSE)
[![GitHub last commit](https://img.shields.io/github/last-commit/ivancarlosti/parkingpage?label=Last%20Commit)](https://github.com/ivancarlosti/parkingpage/commits)
[![Security](https://img.shields.io/badge/Security-View%20Here-purple)](https://github.com/ivancarlosti/parkingpage/security)  
[![Code of Conduct](https://img.shields.io/badge/Code%20of%20Conduct-2.1-4baaaa)](https://github.com/ivancarlosti/parkingpage?tab=coc-ov-file)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/ivancarlosti?label=GitHub%20Sponsors&color=ffc0cb)][sponsor]
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00)][buymeacoffee]
[![Patreon](https://img.shields.io/badge/Patreon-f96854)][patreon]
<!-- endbuttons -->

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

Or use it directly:
```yaml
name: parkingpage
services:
  parkingpage:
    image: ghcr.io/ivancarlosti/parkingpage:latest
    container_name: parkingpage
    restart: unless-stopped
    ports:
      - "10001:80"
```

## Multi-Site Deployment
You can serve multiple domains from a single container by mounting a configuration folder containing `.env` files to `/config/sites`. The container will dynamically generate Nginx configurations and separate HTML files for each site.

Each `.env` file should be named after the site (e.g. `example.com.env`) and contain standard configuration variables like `TITLE`, `SUBTEXT`, etc. Nginx will use the `.env` filename as the `server_name` unless you explicitly override it with a `SERVER_NAME` variable inside the `.env` file.

```yaml
name: parkingpage-multisite
services:
  parkingpage:
    image: ghcr.io/ivancarlosti/parkingpage:latest
    container_name: parkingpage
    restart: unless-stopped
    volumes:
      - ./sites:/config/sites
    ports:
      - "80:80"
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

[cc]: https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/adding-a-code-of-conduct-to-your-project
[contributing]: https://docs.github.com/en/articles/setting-guidelines-for-repository-contributors
[security]: https://docs.github.com/en/code-security/getting-started/adding-a-security-policy-to-your-repository
[support]: https://docs.github.com/en/articles/adding-support-resources-to-your-project
[it]: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository#configuring-the-template-chooser
[prt]: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository
[funding]: https://docs.github.com/en/articles/displaying-a-sponsor-button-in-your-repository
[ivancarlos]: https://ivancarlos.me
[buymeacoffee]: https://buymeacoffee.com/ivancarlos
[patreon]: https://www.patreon.com/ivancarlos
[paypal]: https://icc.gg/donate
[sponsor]: https://github.com/sponsors/ivancarlosti
