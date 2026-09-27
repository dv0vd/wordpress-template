restart:
	- $(MAKE) stop
	- $(MAKE) podman-cleanup
	- $(MAKE) podman-load-images
	- $(MAKE) podman-create-network
	- $(MAKE) start

restart-local:
	- $(MAKE) stop
	- $(MAKE) podman-load-images
	- $(MAKE) podman-create-network
	- $(MAKE) start-local

restart-nginx: stop-nginx start-nginx

restart-nginx-local: stop-nginx start-nginx-local

restart-wordpress: stop-wordpress start-wordpress

restart-db: stop-db start-db

restart-fail2ban: 
	systemctl restart fail2ban

restart-easyappointments: stop-easyappointments start-easyappointments

restart-easyappointments-db: stop-easyappointments-db start-easyappointments-db
