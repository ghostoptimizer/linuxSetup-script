#!/bin/bash
set -e 
set -u

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Try again with: sudo $0"
    exit 1
fi 

LOGILE="./logs/setup-$(date +%F).log"
mkdir -p ./logs 

log() {
    echo "[$(date +%F_%T)] $1" | tee -a "$LOGFILE"
}

set_hostname() {
    local new_hostname="my-linux-machine"
    log "Setting hostname to $new_hostname"
    hostenamectl set-hostname "$new_hostname"
}

set_timezone() {
    local timezone="America/New_York"
    log "Setting timezone to $timezone"
    timedatectl set-time "$timezone"
}

install_packages() {
    local packages=("vim" "curl" "git" "ufw" "htop" "openssh-server")
    log "Installing packages: ${packages[*]}"
    apt-get update
    apt-get install -y "${packages[@]}"
}

create_user() {
    local username="newadmin"
    if id "$username" &>/dev/null; then
        log "User $username already exists"
    else
        log "Creating user $username"
        adduser --disabled-password --gecos "" "$username"
        usermod -aG sudo "$username"
    fi
}

configure_ssh() {
    log "Configuring SSH"
    sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

    if systemctl list-units --type=service | grep -q "sshd.service"; then
        systemctl restart sshd
    elif systemctl list-units --type=service | grep -q "ssh.service"; then
        systemctl restart ssh
    else
        log "SSH service not found. Skipping restart."
    fi
}

main() {
    log "Starting Linux Setup Script"
    set_hostname
    set_timezone
    install_packages
    create_user
    configure_ssh
    log "Setup Complete."
}

main "$@"
