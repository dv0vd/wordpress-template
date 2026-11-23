configure-nginx-local:
	htpasswd -cb ./deployment/configs/nginx/.htpasswd ${NGINX_BASIC_AUTH_USERNAME} ${NGINX_BASIC_AUTH_PASSWORD}
	openssl req -x509 -nodes -newkey rsa:2048 \
		-keyout ./deployment/configs/nginx/nginx.key \
		-out ./deployment/configs/nginx/nginx.crt \
		-subj "/CN=localhost"

ssh-generate-config:
	echo 'PasswordAuthentication no' > /etc/ssh/sshd_config.d/00-wordpress.conf
	echo "Port ${SSH_PORT}" >> /etc/ssh/sshd_config.d/00-wordpress.conf
