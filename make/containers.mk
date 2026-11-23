start:
	- $(MAKE) start-db
	- $(MAKE) start-wordpress
	- $(MAKE) start-nginx
ifeq ($(BACKUP_ENABLED),true)
	- $(MAKE) easyappointments-backup-db
	- $(MAKE) easyappointments-backup-to-storage-vps
endif
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

stop:
	- $(MAKE) stop-nginx
	- $(MAKE) stop-wordpress
	- $(MAKE) stop-db
ifeq ($(EA_ENABLE),true)
	- $(MAKE) stop-easyappointments
	- $(MAKE) stop-easyappointments-db
endif