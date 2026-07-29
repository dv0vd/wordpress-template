certbot-issue:
	- $(MAKE) podman-load-images
	- $(MAKE) podman-create-network
	- $(MAKE) start-nginx-certbot
	- $(MAKE) certbot-issue-website
	- $(MAKE) certbot-issue-old-website
	- $(MAKE) stop-nginx

certbot-issue-website:
	- podman rm certbot
	podman run \
		--rm \
		--name certbot \
		--network podman_network \
		-v ./deployment/data/letsencrypt/data:/etc/letsencrypt \
		-v ./deployment/data/letsencrypt/acme:/app/acme \
		docker.io/certbot/certbot:v5.3.1 certonly \
		--webroot \
		--webroot-path=/app/acme \
		-d ${BASE_URL} \
		-d www.${BASE_URL} \
		--email postmaster@${BASE_URL} \
		--agree-tos \
		--no-eff-email

certbot-issue-old-website:
	@if [ -n "${OLD_BASE_URL}" ]; then \
		podman rm certbot; \
		podman run \
			--rm \
			--name certbot \
			--network podman_network \
			-v ./deployment/data/letsencrypt/data:/etc/letsencrypt \
			-v ./deployment/data/letsencrypt/acme:/app/acme \
			docker.io/certbot/certbot:v5.3.1 certonly \
			--webroot \
			--webroot-path=/app/acme \
			-d ${OLD_BASE_URL} \
			-d www.${OLD_BASE_URL} \
			--email postmaster@${BASE_URL} \
			--agree-tos \
			--no-eff-email; \
	fi

certbot-renew:
	- podman rm certbot
	podman run \
		--rm \
		--name certbot \
		--network podman_network \
		-v ./deployment/data/letsencrypt/data:/etc/letsencrypt \
		-v ./deployment/data/letsencrypt/acme:/app/acme \
		docker.io/certbot/certbot:v5.3.1 renew
