#!/bin/bash
set -e # stop script on any error



configure_dns() {
  log "Configuring DNS..."
  rm -f /etc/resolv.conf
  echo "nameserver 77.88.8.8" > /etc/resolv.conf
  echo "nameserver 1.1.1.1" >> /etc/resolv.conf
  echo "nameserver 8.8.8.8" >> /etc/resolv.conf
  log "DNS successfully configured"
}

configure_git() {
  log "Configuring git..."
  git config --local core.filemode false || true
  log "Git successfully configured"
}

configure_fail2ban() {
  log "Configuring fail2ban..."
  make -C /root/wordpress fail2ban-configure
  systemctl disable fail2ban
  systemctl start fail2ban
  log "Fail2ban successfully configured"
}

configure_nginx() {
  log "Configuring nginx..."
  htpasswd -cb /root/wordpress/deployment/configs/nginx/.htpasswd $NGINX_BASIC_AUTH_USERNAME $NGINX_BASIC_AUTH_PASSWORD
  make -C /root/dv0vd certbot-issue
  log "Nginx successfully configured"
}

configure_ssh() {
  log "Configuring SSH..."
  echo "$SSH_PUBLIC_KEY" >> /root/.ssh/authorized_keys
  make -C /root/dv0vd ssh-generate-config
  envsubst < ./deployment/configs/ssh/ssh_env.conf > /root/.ssh/config
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
  make -C /root/dv0vd podman-pull-images
  make -C /root/dv0vd podman-load-images
  make -C /root/dv0vd podman-create-network
  systemctl set-property podman-group.slice MemoryMax=$PODMAN_MEMORY_LIMIT CPUQuota=$PODMAN_CPUS
  systemctl stop systemd-resolved || true # required for Pi-hole 
  systemctl disable systemd-resolved || true # required for Pi-hole
  log "Podman successfully configured"
}

configure_rclone() {
  log "Configuring rclone..."
  mkdir -p /root/.config/rclone
  touch /root/.config/rclone/rclone.conf
  envsubst < ./deployment/configs/rclone/rclone_env.conf > /root/.config/rclone/rclone.conf
  ssh-keygen -R $RCLONE_HOST || true
  ssh-keyscan -p $RCLONE_PORT $RCLONE_HOST >> /root/.ssh/known_hosts
  log "Rclone successfully configured"
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
  apt install -y rclone
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
configure_git
configure_ssh
configure_podman
if [ "$BACKUP_ENABLED" = "true" ]; then
  configure_rclone
else
  log "Backup is disabled. Skipping rclone configuration"
fi
configure_nginx
finish
