podman-cleanup:
	podman system reset -f

podman-create-network:
	podman network create --ipv6 podman_network

podman-info:
	podman ps -w 1

podman-stats:
	podman stats -i 1

podman-resources:
	systemctl status podman-group.slice
