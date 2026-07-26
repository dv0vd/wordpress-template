iptables-rules-filter:
	iptables -vnL

iptables-rules-nat:
	iptables -t nat -vnL

iptables-rules-raw:
	iptables -t raw -vnL

iptables-rules-mangle:
	iptables -t mangle -vnL

ip6tables-rules-filter:
	ip6tables -vnL

ip6tables-rules-nat:
	ip6tables -t nat -vnL

ip6tables-rules-raw:
	ip6tables -t raw -vnL

ip6tables-rules-mangle:
	ip6tables -t mangle -vnL

iptables-apply-rules:
	bash -c 'set -a; . .env; set +a; envsubst "\$$SSH_PORT" < ./deployment/configs/iptables/iptables_env.sh > ./deployment/configs/iptables/iptables.sh'
	chmod +x ./deployment/configs/iptables/iptables.sh && ./deployment/configs/iptables/iptables.sh
