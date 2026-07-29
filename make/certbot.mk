CERTBOT_OLD_DOMAINS = $(if $(OLD_BASE_URL),-d $(OLD_BASE_URL) -d www.$(OLD_BASE_URL),)

certbot-issue:
	- $(MAKE) podman-load-images
	- $(MAKE) podman-create-network
	- $(MAKE) start-nginx-certbot
	- $(MAKE) certbot-issue-website
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
		${CERTBOT_OLD_DOMAINS} \
		--email postmaster@${BASE_URL} \
		--agree-tos \
		--no-eff-email

certbot-renew:
	- podman rm certbot
	podman run \
		--rm \
		--name certbot \
		--network podman_network \
		-v ./deployment/data/letsencrypt/data:/etc/letsencrypt \
		-v ./deployment/data/letsencrypt/acme:/app/acme \
		docker.io/certbot/certbot:v5.3.1 renew
