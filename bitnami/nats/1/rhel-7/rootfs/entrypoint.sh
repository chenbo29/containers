#!/bin/bash

CONF_FILE='/opt/bitnami/nats/gnatsd.conf';

if [ ! -e ${CONF_FILE} ]; then
    echo "==> Writing config file..."
    cat > ${CONF_FILE} << EOF
# Client port of 4222 on all interfaces
port: 4222

# HTTP monitoring port
monitor_port: 8222

# This is for clustering multiple servers together.
cluster {

  # Route connections to be received on any interface on port 6222
  port: 6222

  # Routes are protected, so need to use them with --routes flag
  # e.g. --routes=nats-route://ruser:T0pS3cr3t@otherdockerhost:6222
  authorization {
    user: ruser
    password: T0pS3cr3t
    timeout: 2
  }

  # Routes are actively solicited and connected to from this server.
  # This Docker image has none by default, but you can pass a
  # flag to the gnatsd docker image to create one to an existing server.
  routes = []
}
EOF
else
    echo "==> Detected config file. It would be used instead of creating one."
fi

exec gnatsd -c "$CONF_FILE"
