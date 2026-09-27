stop:
	- $(MAKE) stop-nginx
	- $(MAKE) stop-wordpress
	- $(MAKE) stop-db
ifeq ($(EA_ENABLE),true)
	- $(MAKE) stop-easyappointments
	- $(MAKE) stop-easyappointments-db
endif

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

stop-easyappointments:
	- podman stop easyappointments
	- podman rm easyappointments

stop-easyappointments-db:
	- podman stop easyappointments-db
	- podman rm easyappointments-db
