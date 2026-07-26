enter-nginx:
	podman exec -it nginx sh

enter-db:
	podman exec -it db bash

enter-wordpress:
	podman exec -it wordpress bash