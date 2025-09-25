# Parking Page
Dynamic HTML to put on parking domains

<!-- buttons -->
[![Stars](https://img.shields.io/github/stars/ivancarlosti/parkingpage?label=⭐%20Stars&color=gold&style=flat)](https://github.com/ivancarlosti/parkingpage/stargazers)
[![Watchers](https://img.shields.io/github/watchers/ivancarlosti/parkingpage?label=Watchers&style=flat&color=red)](https://github.com/sponsors/ivancarlosti)
[![Forks](https://img.shields.io/github/forks/ivancarlosti/parkingpage?label=Forks&style=flat&color=ff69b4)](https://github.com/sponsors/ivancarlosti)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/ivancarlosti/parkingpage?label=Activity)](https://github.com/ivancarlosti/parkingpage/pulse)
[![GitHub Issues](https://img.shields.io/github/issues/ivancarlosti/parkingpage?label=Issues&color=orange)](https://github.com/ivancarlosti/parkingpage/issues)
[![License](https://img.shields.io/github/license/ivancarlosti/parkingpage?label=License)](LICENSE)  
[![GitHub last commit](https://img.shields.io/github/last-commit/ivancarlosti/parkingpage?label=Last%20Commit)](https://github.com/ivancarlosti/parkingpage/commits)
[![Security](https://img.shields.io/badge/Security-View%20Here-purple)](https://github.com/ivancarlosti/parkingpage/security)
[![Code of Conduct](https://img.shields.io/badge/Code%20of%20Conduct-2.1-4baaaa)](https://github.com/ivancarlosti/parkingpage?tab=coc-ov-file)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/ivancarlosti?label=GitHub%20Sponsors&color=ffc0cb)][sponsor]
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
```

<!-- footer -->
---

## 🧑‍💻 Consulting and technical support
* For personal support and queries, please submit a new issue to have it addressed.
* For commercial related questions, please contact me directly for consulting costs. 

## 🩷 Project support
| If you found this project helpful, consider |
| :---: |
[**buying me a coffee**][buymeacoffee], [**donate by paypal**][paypal], [**sponsor this project**][sponsor] or just [**leave a star**](../..)⭐
|Thanks for your support, it is much appreciated!|

## 🌐 Connect with me
[![LinkedIn](https://img.shields.io/badge/LinkedIn-@ivancarlos-0077B5)](https://www.linkedin.com/in/ivancarlos)
[![X](https://img.shields.io/badge/X-@ivancarlos-000000)](https://x.com/ivancarlos)  
[![Signal](https://img.shields.io/badge/Signal-@ivancarlos.01-2592E9)](https://icc.gg/signal)
[![Telegram](https://img.shields.io/badge/Telegram-@ivancarlos-26A5E4)](https://t.me/ivancarlos)  
[![Discord](https://img.shields.io/badge/Discord-@ivancarlos.me-5865F2)](https://icc.gg/discord)
[![Website](https://img.shields.io/badge/Website-ivancarlos.me-FF6B6B)](https://ivancarlos.me)

[cc]: https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/adding-a-code-of-conduct-to-your-project
[contributing]: https://docs.github.com/en/articles/setting-guidelines-for-repository-contributors
[security]: https://docs.github.com/en/code-security/getting-started/adding-a-security-policy-to-your-repository
[support]: https://docs.github.com/en/articles/adding-support-resources-to-your-project
[it]: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository#configuring-the-template-chooser
[prt]: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository
[funding]: https://docs.github.com/en/articles/displaying-a-sponsor-button-in-your-repository
[ivancarlos]: https://ivancarlos.me
[buymeacoffee]: https://www.buymeacoffee.com/ivancarlos
[paypal]: https://icc.gg/donate
[sponsor]: https://github.com/sponsors/ivancarlosti
