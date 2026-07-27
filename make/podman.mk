podman-cleanup:
	podman system reset -f

podman-create-network:
	podman network create --ipv6 podman_network

podman-load-images:
	podman load < ./deployment/images/wordpress_7.0.2-php8.5-fpm.tar
	podman load < ./deployment/images/mariadb_12.1.2.tar
	podman load < ./deployment/images/nginx_1.27.3.tar
	podman load < ./deployment/images/certbot_5.3.1.tar

podman-info:
	podman ps -w 1

podman-stats:
	podman stats -i 1

podman-resources:
	systemctl status podman-group.slice
