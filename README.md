# WordPress Template
## https://github.com/dv0vd/wordpress-template
Template for deploying a WordPress website with MariaDB, Nginx, Fail2ban, SSH hardening, Let's Encrypt certificates, and Podman-based container management.

## Getting started
1) Update packages index: `apt update`.
2) Install git: `apt install git`.
3) Clone repo: `git clone https://github.com/dv0vd/wordpress-template.git wordpress`.
4) Go to the project directory: `cd ./wordpress`.
5) Configure the `.env` file.
6) Copy Podman images to `./deployment/images`:
- wordpress_7.0.2-php8.5-fpm.tar
- mariadb_12.1.2.tar
- nginx_1.27.3.tar
- certbot_5.3.1.tar
- alextselegidis-easyappointments_1.6.0.tar (optional, only when `EA_ENABLE=true`)
7) Run the initialization script `chmod +x ./deployment/init.sh && ./deployment/init.sh`.

## Old website redirect (optional)
Redirects requests of a previously used domain to the current one. `OLD_BASE_URL` — old host without scheme, e.g. `old-example.com`. The redirect works only if the variable is specified.

## Easy!Appointments (optional)
Online booking module, disabled by default. Set `EA_ENABLE=true` in `.env` to create and start it.

