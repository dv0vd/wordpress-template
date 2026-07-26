stop:
	- $(MAKE) stop-nginx
	- $(MAKE) stop-wordpress
	- $(MAKE) stop-db

stop-nginx:
	- podman stop nginx
	- podman rm nginx

stop-db:
	- podman stop db
	- podman rm db

stop-wordpress:
	- podman stop wordpress
	- podman rm wordpress

stop-fail2ban:
	systemctl disable fail2ban
	systemctl stop fail2ban
