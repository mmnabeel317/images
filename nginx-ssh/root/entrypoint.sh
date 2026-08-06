#!/bin/sh

set -e

mkdir -p /run/sshd

# Set up root's SSH access. Prefer a supplied public key, otherwise fall
# back to a password (random unless one is supplied via SSH_PASSWORD).
if [ -n "$SSH_AUTHORIZED_KEYS" ]; then
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
    echo "$SSH_AUTHORIZED_KEYS" > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi

if [ -n "$SSH_PASSWORD" ]; then
    echo "root:${SSH_PASSWORD}" | chpasswd
else
    SSH_PASSWORD=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)
    echo "root:${SSH_PASSWORD}" | chpasswd
    echo "No SSH_PASSWORD set, generated random root password: ${SSH_PASSWORD}"
fi

/usr/sbin/sshd

exec /usr/sbin/nginx -g "daemon off;"
