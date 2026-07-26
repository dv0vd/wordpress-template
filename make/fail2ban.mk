fail2ban-configure:
	bash -c "set -a; . .env; set +a; envsubst < ./deployment/configs/fail2ban/jail_env.local > ./deployment/configs/fail2ban/jail.local"
	cp ./deployment/configs/fail2ban/jail.local /etc/fail2ban/jail.local
	cp ./deployment/configs/fail2ban/fail2ban.local /etc/fail2ban/fail2ban.local
	cp ./deployment/configs/fail2ban/filters/nginx-not-found.local /etc/fail2ban/filter.d
	cp ./deployment/configs/fail2ban/filters/nginx-redirected.local /etc/fail2ban/filter.d
	mkdir -p ./deployment/data/nginx/logs && touch ./deployment/data/nginx/logs/error.log
	mkdir -p ./deployment/data/nginx/logs && touch ./deployment/data/nginx/logs/access.log

fail2ban-status:
	fail2ban-client status
	fail2ban-client status sshd
	fail2ban-client status nginx-http-auth
	fail2ban-client status nginx-limit-req
	fail2ban-client status nginx-botsearch
	fail2ban-client status nginx-bad-request
	fail2ban-client status nginx-not-found
	fail2ban-client status nginx-redirected

fail2ban-unban-all:
	fail2ban-client unban --all