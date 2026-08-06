### Setup user for build execution and application runtime
FROM registry.access.redhat.com/ubi9/ubi-minimal
COPY root ./

RUN microdnf -y --setopt=tsflags=nodocs install nginx openssh-server openssh-clients shadow-utils && \
    chmod 755 /etc/nginx/ssl && \
    chmod +x /entrypoint.sh && \
    ssh-keygen -A && \
    useradd -m -s /bin/bash sshtest && \
    # Kubernetes mounts a Secret volume over this exact path at runtime
    # (deployment-server.yml), so this is only ever used as-is when running
    # the image standalone (e.g. podman run) without that mount.
    mkdir -p /etc/ssh-authorized-keys && \
    chmod 755 /etc/ssh-authorized-keys && \
    microdnf clean all

EXPOSE 8080 8443 22

### Provide defaults for an executing container
CMD ["./entrypoint.sh"]
