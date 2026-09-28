# WordPress Template
## https://github.com/dv0vd/wordpress-template
Template for deploying a WordPress website with MariaDB, Nginx, Fail2ban, SSH hardening, Let's Encrypt certificates, and Podman-based container management.

## Getting started
1) Update packages index: `apt update`.
2) Install git: `apt install git`.
3) Copy storage-vps SSH private key to `/root/.ssh/vps-storage` for storage vps backups. (optional, only when `BACKUP_ENABLED=true`)
4) Clone repo: `git clone https://github.com/dv0vd/wordpress-template.git wordpress`.
5) Go to the project directory: `cd ./wordpress`.
6) Configure the `.env` file.
7) Copy Podman images to `./deployment/images`:
- wordpress_7.0.2-php8.5-fpm.tar
- mariadb_12.1.2.tar
- nginx_1.27.3.tar
- certbot_5.3.1.tar
- alextselegidis-easyappointments_1.6.0.tar (optional, only when `EA_ENABLE=true`)
8) Run the initialization script `chmod +x ./deployment/init.sh && ./deployment/init.sh`.

## Old website redirect (optional)
Redirects requests of a previously used domain to the current one. `OLD_BASE_URL` — old host without scheme, e.g. `old-example.com`. The redirect works only if the variable is specified.

## Easy!Appointments (optional)
Online booking module, disabled by default. Set `EA_ENABLE=true` in `.env` to create and start it.

## Easy!Appointments database backup (optional)
Requires `BACKUP_ENABLED=true` and a running `easyappointments-db` container. Dumps are created with `mariadb-dump` and stored in `./deployment/data/easyappointments/mariadb/backups`. The last three dumps are kept: `0.dump` (newest), `1.dump` and `2.dump`.
1) `make easyappointments-backup-db` — create a `mariadb-dump` snapshot of the `EA_DB_NAME` database.
2) `make easyappointments-restore-db` — load the newest dump `0.dump` into the `EA_DB_NAME` database.
3) `make easyappointments-backup-to-storage-vps` — sync local dumps to the storage VPS (`vps-storage-bg-angel` rclone remote).
4) `make easyappointments-restore-from-storage-vps` — download dumps from the storage VPS to `./deployment/restore/easyappointments` (nothing is loaded into the database).

