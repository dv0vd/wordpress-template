enter-nginx:
	podman exec -it nginx sh

enter-db:
	podman exec -it db bash

enter-wordpress:
	podman exec -it wordpress bash

enter-easyappointments:
	podman exec -it easyappointments bash

enter-easyappointments-db:
	podman exec -it easyappointments-db bash