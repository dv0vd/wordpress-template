GREEN='\033[1;32m'
WHITE='\033[1;37m'
RESET='\033[0m'
help:
	@echo ${GREEN}start'                                   '${WHITE}— start application containers${RESET}
	@echo ${GREEN}start-local'                             '${WHITE}— start application containers locally${RESET}
	@echo ${GREEN}start-db'                                '${WHITE}— start database${RESET}
	@echo ${GREEN}start-nginx'                             '${WHITE}— start nginx server${RESET}
	@echo ${GREEN}start-nginx-local'                       '${WHITE}— start local nginx server${RESET}
	@echo ${GREEN}start-wordpress'                         '${WHITE}— start wordpress${RESET}
	@echo ${GREEN}start-fail2ban'                          '${WHITE}— start fail2ban${RESET}
	@echo ${GREEN}configure-nginx-local'                   '${WHITE}— configure local nginx basic auth and TLS certificate${RESET}
	@echo ${GREEN}stop'                                    '${WHITE}— stop application containers${RESET}
	@echo ${GREEN}stop-db'                                 '${WHITE}— stop database${RESET}
	@echo ${GREEN}stop-nginx'                              '${WHITE}— stop nginx server${RESET}
	@echo ${GREEN}stop-wordpress'                          '${WHITE}— stop wordpress${RESET}
	@echo ${GREEN}stop-fail2ban'                           '${WHITE}— stop fail2ban${RESET}
	@echo ${GREEN}restart'                                 '${WHITE}— restart application containers${RESET}
	@echo ${GREEN}restart-local'                           '${WHITE}— restart application containers locally${RESET}
	@echo ${GREEN}restart-db'                              '${WHITE}— restart database${RESET}
	@echo ${GREEN}restart-nginx'                           '${WHITE}— restart nginx server${RESET}
	@echo ${GREEN}restart-nginx-local'                     '${WHITE}— restart local nginx server${RESET}
	@echo ${GREEN}restart-wordpress'                       '${WHITE}— restart wordpress${RESET}
	@echo ${GREEN}restart-fail2ban'                        '${WHITE}— restart fail2ban${RESET}
	@echo ${GREEN}logs-clear'                              '${WHITE}— clear journalctl logs older than 1 day${RESET}
	@echo ${GREEN}logs-db'                                 '${WHITE}— get database logs${RESET}
	@echo ${GREEN}logs-nginx'                              '${WHITE}— get nginx logs${RESET}
	@echo ${GREEN}logs-nginx-access'                       '${WHITE}— get nginx access logs${RESET}
	@echo ${GREEN}logs-nginx-error'                        '${WHITE}— get nginx error logs${RESET}
	@echo ${GREEN}logs-wordpress'                          '${WHITE}— get wordpress logs${RESET}
	@echo ${GREEN}logs-auth'                               '${WHITE}— get SSH connection attempts logs${RESET}
	@echo ${GREEN}logs-init'                               '${WHITE}— get init logs${RESET}
	@echo ${GREEN}logs-startup'                            '${WHITE}— get startup logs${RESET}
	@echo ${GREEN}logs-fail2ban'                           '${WHITE}— get fail2ban logs${RESET}
	@echo ${GREEN}fail2ban-status'                         '${WHITE}— get fail2ban jails status${RESET}
	@echo ${GREEN}fail2ban-unban-all'                      '${WHITE}— unban all IPs in fail2ban${RESET}
	@echo ${GREEN}podman-load-images'                      '${WHITE}— load images from local copy${RESET}
	@echo ${GREEN}podman-cleanup'                          '${WHITE}— clean all podman resources${RESET}
	@echo ${GREEN}podman-create-network'                   '${WHITE}— create custom podman network with ipv6 support${RESET}
	@echo ${GREEN}podman-stats'                            '${WHITE}— get containers stats${RESET}
	@echo ${GREEN}podman-info'                             '${WHITE}— get containers list with info${RESET}
	@echo ${GREEN}podman-resources'                        '${WHITE}— get podman resource limits and usage${RESET}
	@echo ${GREEN}on-startup'                              '${WHITE}— commands to execute immediately after server startup${RESET}
	@echo ${GREEN}fail2ban-configure'                      '${WHITE}— configure fail2ban${RESET}
	@echo ${GREEN}certbot-issue'                           '${WHITE}— issue certbot certificates${RESET}
	@echo ${GREEN}certbot-issue-website'                   '${WHITE}— issue website certbot certificates${RESET}
	@echo ${GREEN}certbot-renew'                           '${WHITE}— renew certbot certificates${RESET}
	@echo ${GREEN}certbot-delete-certificate'              '${WHITE}— delete certbot certificate by URL${RESET}
	@echo ${GREEN}enter-db'                                '${WHITE}— enter database container${RESET}
	@echo ${GREEN}enter-nginx'                             '${WHITE}— enter nginx container${RESET}
	@echo ${GREEN}enter-wordpress'                         '${WHITE}— enter wordpress container${RESET}
	@echo ${GREEN}enter-easyappointments'                  '${WHITE}— enter easyappointments container${RESET}
	@echo ${GREEN}enter-easyappointments-db'               '${WHITE}— enter easyappointments database container${RESET}
	@echo ${GREEN}start-easyappointments'                  '${WHITE}— start Easy!Appointments${RESET}
	@echo ${GREEN}start-easyappointments-db'               '${WHITE}— start Easy!Appointments database${RESET}
	@echo ${GREEN}stop-easyappointments'                   '${WHITE}— stop Easy!Appointments${RESET}
	@echo ${GREEN}stop-easyappointments-db'                '${WHITE}— stop Easy!Appointments database${RESET}
	@echo ${GREEN}restart-easyappointments'                '${WHITE}— restart Easy!Appointments${RESET}
	@echo ${GREEN}restart-easyappointments-db'             '${WHITE}— restart Easy!Appointments database${RESET}
	@echo ${GREEN}logs-easyappointments'                   '${WHITE}— get Easy!Appointments logs${RESET}
	@echo ${GREEN}logs-easyappointments-db'                '${WHITE}— get Easy!Appointments database logs${RESET}