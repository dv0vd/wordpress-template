easyappointments-backup-db:
	- cp ./deployment/data/easyappointments/mariadb/backups/1.dump ./deployment/data/easyappointments/mariadb/backups/2.dump
	- rm ./deployment/data/easyappointments/mariadb/backups/1.dump
	- cp ./deployment/data/easyappointments/mariadb/backups/0.dump ./deployment/data/easyappointments/mariadb/backups/1.dump
	podman exec -i -u root easyappointments-db sh -c 'mariadb-dump -u root -p${EA_DB_ROOT_PASSWORD} --single-transaction --quick --routines --events ${EA_DB_NAME} > /backups/0.dump'
	- rm ./deployment/data/easyappointments/mariadb/backups/2.dump

easyappointments-restore-db:
	podman exec -i easyappointments-db sh -c 'mariadb -v -u root -p${EA_DB_ROOT_PASSWORD} ${EA_DB_NAME} < /backups/0.dump'

easyappointments-backup-to-storage-vps:
	- rclone sync -v '/root/wordpress/deployment/data/easyappointments/mariadb/backups' 'vps-storage-bg-angel:/'

easyappointments-restore-from-storage-vps:
	- rclone sync -v 'vps-storage-bg-angel:/' '/root/wordpress/deployment/restore/easyappointments'