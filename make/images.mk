podman-pull-images:
	podman pull docker.io/wordpress:7.1.5-php8.5-fpm
	podman pull docker.io/mariadb:13.0.2
	podman pull docker.io/nginx:1.31.9
	podman pull docker.io/certbot/certbot:v5.10.0
ifeq ($(EA_ENABLE),true)
	podman pull docker.io/alextselegidis/easyappointments:1.6.0
endif

	podman save docker.io/wordpress:7.1.5-php8.5-fpm > ./deployment/images/wordpress.tar
	podman save docker.io/mariadb:13.0.2 > ./deployment/images/mariadb.tar
	podman save docker.io/nginx:1.31.9 > ./deployment/images/nginx.tar
	podman save docker.io/certbot/certbot:v5.10.0 > ./deployment/images/certbot.tar
ifeq ($(EA_ENABLE),true)
	podman save docker.io/alextselegidis/easyappointments:1.6.0 > ./deployment/images/easyappointments.tar
endif

podman-load-images:
	podman load < ./deployment/images/wordpress.tar
	podman load < ./deployment/images/mariadb.tar
	podman load < ./deployment/images/nginx.tar
	podman load < ./deployment/images/certbot.tar
ifeq ($(EA_ENABLE),true)
	podman load < ./deployment/images/easyappointments.tar
endif
