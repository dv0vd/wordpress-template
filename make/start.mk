start:
	- $(MAKE) start-db
	- $(MAKE) start-wordpress
	- $(MAKE) start-nginx

start-local:
	- $(MAKE) start-db
	- $(MAKE) start-wordpress
	- $(MAKE) start-nginx-local

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
	-@ rm ./deployment/data/nginx/logs/access.log
	-@ rm ./deployment/data/nginx/logs/error.log
	- podman run \
	-d \
	--name nginx \
	--network podman_network \
	-v ./deployment/configs/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
	-v ./deployment/configs/nginx/.htpasswd:/etc/nginx/.htpasswd:ro \
	-v ./deployment/data/nginx/logs:/var/log/nginx \
	-v ./deployment/data/letsencrypt/acme:/app/letsencrypt/acme:ro \
	-v ./deployment/data/letsencrypt/data:/app/letsencrypt/certificates:ro \
	-v ./src/:/var/www/html \
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
	--restart unless-stopped \
	--memory=${NGINX_MEMORY} \
	--cpus=${NGINX_CPUS} \
	--cgroup-parent=/podman-group.slice \
	docker.io/nginx:1.27.3

start-nginx-local:
	- bash -c "set -a; . .env; set +a; envsubst '\$$BASE_URL' < ./deployment/configs/nginx/local_env.conf > ./deployment/configs/nginx/nginx.conf"
	-@ rm ./deployment/data/nginx/logs/access.log
	-@ rm ./deployment/data/nginx/logs/error.log
	- podman run \
	-d \
	--name nginx \
	--network podman_network \
	-v ./deployment/configs/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
	-v ./deployment/configs/nginx/.htpasswd:/etc/nginx/.htpasswd:ro \
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
