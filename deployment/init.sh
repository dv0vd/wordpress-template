#!/bin/bash
set -e # stop script on any error



configure_fail2ban() {
  log "Configuring fail2ban..."
  make -C /root/wordpress fail2ban-configure
  systemctl disable fail2ban
  systemctl start fail2ban
  log "Fail2ban successfully configured"
}

configure_nginx() {
  log "Configuring nginx..."
  htpasswd -cb /root/wordpress/deployment/configs/nginx/.htpasswd $NGINX_BASIC_AUTH_USERNAME $NGINX_BASIC_AUTH_PASSWORD &&
  make -C /root/wordpress certbot-issue
  log "Nginx successfully configured"
}

configure_ssh() {
  log "Configuring SSH..."
  echo "$SSH_PUBLIC_KEY" >> /root/.ssh/authorized_keys
  touch /etc/ssh/sshd_config.d/00-wordpress.conf
  echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config.d/00-wordpress.conf
  echo Port $SSH_PORT >> /etc/ssh/sshd_config.d/00-wordpress.conf
  chmod 600 /root/.ssh/config
  log "SSH successfully generated"
}

configure_podman() {
  log "Configuring Podman..."
  # apt install -y pipx && 
  # pipx install podman-compose &&
  # pipx ensurepath &&
  systemctl enable podman
  systemctl start podman
  podman system prune --all -f
  systemctl set-property podman-group.slice MemoryMax=$PODMAN_MEMORY_LIMIT CPUQuota=$PODMAN_CPUS
  systemctl stop systemd-resolved || true # required for Pi-hole 
  systemctl disable systemd-resolved || true # required for Pi-hole
  log "Podman successfully configured"
}

finish() {
  log "Configuring rc.local autostart..."
  rm /etc/rc.local -f
  cp /root/wordpress/deployment/configs/linux/rc.local /etc/rc.local
  chmod a+x /etc/rc.local
  log "rc.local autostart successfully configured"
  log "Initialization finished. Rebooting now..."
  reboot
}

install_packages() {
  log "Updating system and installing required packages..."
  apt update
  apt upgrade -y
  apt install -y make
  apt install -y curl
  apt install -y git
  apt install -y apache2-utils # for nginx basic auth
  apt install -y fail2ban
  apt install -y podman
  apt install -y iptables
  apt install -y ipset # for iptables
  apt install -y gettext # for envsubst
  apt install dnsutils # for dig
  log "Packages successfully installed"
}

load_env() {
  log "Loading environment variables..."
  set -a
  source .env
  set +a
  log "Environment variables successfully loaded"
}

log() {
  local log_file="/var/log/init.log"
  local msg="$1"
  local ts
  ts=$(date +"%F %T")
  local line="===================================================================="
  echo -e "\n$line" | tee -a "$log_file"
  echo "[INIT][$ts] $msg" | tee -a "$log_file"
  echo "$line" | tee -a "$log_file"
}

set_timezone() {
  log "Setting timezone to UTC..."
  timedatectl set-timezone UTC
  log "Timezone successfully set"
}



load_env
set_timezone
install_packages
configure_ssh
configure_podman
configure_nginx
configure_fail2ban
finish
