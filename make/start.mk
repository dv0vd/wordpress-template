start:
	- $(MAKE) start-db
	- $(MAKE) start-wordpress
	- $(MAKE) start-nginx
ifeq ($(EA_ENABLE),true)
	- $(MAKE) start-easyappointments-db
	- $(MAKE) start-easyappointments
endif

start-local:
	- $(MAKE) start-db
	- $(MAKE) start-wordpress
	- $(MAKE) start-nginx-local
ifeq ($(EA_ENABLE),true)
	- $(MAKE) start-easyappointments-db
	- $(MAKE) start-easyappointments
endif

start-wordpress:
	- chmod a+rwX ./src
	- podman run \
	-d \
	--name wordpress \
	-v ./src/:/var/www/html \
	-v ./deployment/configs/php/uploads.ini:/usr/local/etc/php/conf.d/uploads.ini:ro \
	-e WORDPRESS_DB_HOST=${DB_HOST} \
	-e WORDPRESS_DB_USER=${DB_USER} \
	-e WORDPRESS_DB_PASSWORD=${DB_PASSWORD} \
	-e WORDPRESS_DB_NAME=${DB_NAME} \
	-e WORDPRESS_TABLE_PREFIX="${APP_NAME}_" \
	--network podman_network \
	--restart unless-stopped \
	--memory=${WORDPRESS_MEMORY} \
	--cpus=${WORDPRESS_CPUS} \
	--cgroup-parent=/podman-group.slice \
	docker.io/wordpress:7.0.2-php8.5-fpm

start-db:
	- mkdir -p ./deployment/data/mariadb/data
	- podman run \
	-d \
	--name db \
	-v ./deployment/data/mariadb/data:/var/lib/mysql \
	-e MARIADB_DATABASE=${DB_NAME} \
	-e MARIADB_USER=${DB_USER} \
	-e MARIADB_PASSWORD=${DB_PASSWORD} \
	-e MARIADB_ROOT_PASSWORD=${DB_ROOT_PASSWORD} \
	-p 127.0.0.1:${DB_HOST_PORT}:3306 \
	--network podman_network \
	--restart unless-stopped \
	--memory=${DB_MEMORY} \
	--cpus=${DB_CPUS} \
	--cgroup-parent=/podman-group.slice \
	docker.io/mariadb:12.1.2

start-nginx:
	- bash -c "set -a; . .env; set +a; envsubst '\$$BASE_URL' < ./deployment/configs/nginx/nginx_env.conf > ./deployment/configs/nginx/nginx.conf"
	- bash -c "set -a; . .env; set +a; if [ -n \"\$$OLD_BASE_URL\" ]; then envsubst '\$$BASE_URL \$$OLD_BASE_URL' < ./deployment/configs/nginx/old-site-redirect_env.conf > ./deployment/configs/nginx/old-site-redirect.conf; else printf '' > ./deployment/configs/nginx/old-site-redirect.conf; fi"
	- bash -c "set -a; . .env; set +a; if [ \"\$$EA_ENABLE\" = \"true\" ]; then envsubst '\$$EA_URL \$$BASE_URL' < ./deployment/configs/nginx/easyappointments_env.conf > ./deployment/configs/nginx/easyappointments.conf; else printf '' > ./deployment/configs/nginx/easyappointments.conf; fi"
	-@ rm ./deployment/data/nginx/logs/access.log
	-@ rm ./deployment/data/nginx/logs/error.log
	- podman run \
	-d \
	--name nginx \
	--network podman_network \
	-v ./deployment/configs/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
	-v ./deployment/configs/nginx/old-site-redirect.conf:/etc/nginx/conf.d/old-site-redirect.conf:ro \
	-v ./deployment/configs/nginx/easyappointments.conf:/etc/nginx/conf.d/easyappointments.conf:ro \
	-v ./deployment/configs/nginx/.htpasswd:/etc/nginx/.htpasswd:ro \
	-v ./deployment/data/nginx/logs:/var/log/nginx \
	-v ./deployment/data/letsencrypt/acme:/app/letsencrypt/acme:ro \
	-v ./deployment/data/letsencrypt/data:/app/letsencrypt/certificates:ro \
	-v ./src/:/var/www/html \
	-p 80:80 \
	-p 443:443 \
	--restart unless-stopped \
	--memory=${NGINX_MEMORY} \
	--cpus=${NGINX_CPUS} \
	--cgroup-parent=/podman-group.slice \
	docker.io/nginx:1.27.3

start-nginx-certbot:
	- bash -c "set -a; . .env; set +a; envsubst '\$$BASE_URL' < ./deployment/configs/nginx/certbot_env.conf > ./deployment/configs/nginx/nginx.conf"
	-@ rm ./deployment/data/nginx/logs/access.log
	-@ rm ./deployment/data/nginx/logs/error.log
	- podman run \
	-d \
	--name nginx \
	--network podman_network \
	-v ./deployment/configs/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
	-v ./deployment/data/nginx/logs:/var/log/nginx \
	-v ./deployment/data/letsencrypt/acme:/app/letsencrypt/acme:ro \
	-v ./src/:/var/www/html \
	-p 80:80 \
	--restart unless-stopped \
	--memory=${NGINX_MEMORY} \
	--cpus=${NGINX_CPUS} \
	--cgroup-parent=/podman-group.slice \
	docker.io/nginx:1.27.3

start-nginx-local:
	- bash -c "set -a; . .env; set +a; envsubst '\$$BASE_URL' < ./deployment/configs/nginx/local_env.conf > ./deployment/configs/nginx/nginx.conf"
	- bash -c "set -a; . .env; set +a; if [ \"\$$EA_ENABLE\" = \"true\" ]; then envsubst '\$$EA_URL \$$BASE_URL' < ./deployment/configs/nginx/easyappointments_local_env.conf > ./deployment/configs/nginx/easyappointments.conf; else printf '' > ./deployment/configs/nginx/easyappointments.conf; fi"
	-@ rm ./deployment/data/nginx/logs/access.log
	-@ rm ./deployment/data/nginx/logs/error.log
	- podman run \
	-d \
	--name nginx \
	--network podman_network \
	-v ./deployment/configs/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
	-v ./deployment/configs/nginx/.htpasswd:/etc/nginx/.htpasswd:ro \
	-v ./deployment/configs/nginx/easyappointments.conf:/etc/nginx/conf.d/easyappointments.conf:ro \
	-v ./deployment/configs/nginx:/deployment/nginx:ro \
	-v ./deployment/data/nginx/logs:/var/log/nginx \
	-v ./src/:/var/www/html \
	-p ${NGINX_LOCAL_PORT}:443 \
	--restart unless-stopped \
	--memory=${NGINX_MEMORY} \
	--cpus=${NGINX_CPUS} \
	docker.io/nginx:1.27.3

start-fail2ban:
	systemctl start fail2ban

start-easyappointments:
	- chmod -R a+rwX ./deployment/data/easyappointments/data
	- podman run \
	-d \
	--name easyappointments \
	-v ./deployment/data/easyappointments/data:/var/www/html/storage \
	-v ./deployment/configs/easyappointments/remoteip.conf:/etc/apache2/conf-enabled/zz-easyappointments-remoteip.conf:ro \
	-v ./deployment/configs/easyappointments/security_headers.php:/var/www/html/application/hooks/security_headers.php:ro \
	-v ./deployment/configs/easyappointments/email.php:/var/www/html/application/config/email.php:ro \
	-e BASE_URL=https://${EA_URL}.${BASE_URL} \
	-e DB_HOST=easyappointments-db \
	-e DB_NAME=${EA_DB_NAME} \
	-e DB_USERNAME=${EA_DB_USER} \
	-e DB_PASSWORD=${EA_DB_PASSWORD} \
	-e MAIL_PROTOCOL=smtp \
	-e MAIL_SMTP_DEBUG=0 \
	-e MAIL_SMTP_AUTH=1 \
	-e MAIL_SMTP_HOST=${SMTP_HOST} \
	-e MAIL_SMTP_USER=${SMTP_USER} \
	-e MAIL_SMTP_PASS=${SMTP_PASS} \
	-e MAIL_SMTP_PORT=${SMTP_PORT} \
	-p 127.0.0.1:${EA_HOST_PORT}:80 \
	--network podman_network \
	--restart unless-stopped \
	--memory=${EA_MEMORY} \
	--cpus=${EA_CPUS} \
	--cgroup-parent=/podman-group.slice \
	docker.io/alextselegidis/easyappointments:1.6.0

start-easyappointments-db:
	- podman run \
	-d \
	--name easyappointments-db \
	-v ./deployment/data/easyappointments/mariadb/data:/var/lib/mysql \
	-e MARIADB_DATABASE=${EA_DB_NAME} \
	-e MARIADB_USER=${EA_DB_USER} \
	-e MARIADB_PASSWORD=${EA_DB_PASSWORD} \
	-e MARIADB_ROOT_PASSWORD=${EA_DB_ROOT_PASSWORD} \
	-p 127.0.0.1:${EA_DB_HOST_PORT}:3306 \
	--network podman_network \
	--restart unless-stopped \
	--memory=${EA_DB_MEMORY} \
	--cpus=${EA_DB_CPUS} \
	--cgroup-parent=/podman-group.slice \
	docker.io/mariadb:12.1.2
