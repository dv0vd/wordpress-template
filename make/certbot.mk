certbot-issue:
	- $(MAKE) certbot-issue-website

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

certbot-renew:
	- podman rm certbot
	podman run \
		--rm \
		--name certbot \
		--network podman_network \
		-v ./deployment/data/letsencrypt/data:/etc/letsencrypt \
		-v ./deployment/data/letsencrypt/acme:/app/acme \
		docker.io/certbot/certbot:v5.3.1 renew
