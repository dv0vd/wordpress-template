logs-clear:
	journalctl --vacuum-time=1d

logs-nginx:
	podman logs -f nginx

logs-nginx-access:
	tail -f -n +1 deployment/data/nginx/logs/access.log

logs-nginx-error:
	tail -f -n +1 deployment/data/nginx/logs/error.log

logs-fail2ban:
	tail -f -n +1 /var/log/fail2ban.log

logs-auth:
	journalctl -u ssh -n 10000 -f
	
logs-init:
	cat /var/log/init.log

logs-startup:
	cat /var/log/on-startup.log

logs-wordpress:
	podman logs -f wordpress

logs-db:
	podman logs -f db

logs-easyappointments:
	podman logs -f easyappointments

logs-easyappointments-db:
	podman logs -f easyappointments-db
