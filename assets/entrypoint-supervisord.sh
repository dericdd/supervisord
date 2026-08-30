#!/bin/bash
set -euo pipefail

# >> Overwrite Original Supervisord.conf:
cat << 'EOF' > /etc/supervisord.conf
[supervisord]
user=root
nodaemon=true
logfile=/dev/null
pidfile=/var/run/supervisord.pid
logfile_maxbytes=0
logfile_backups=0

[unix_http_server]
file=/var/run/supervisor.sock
chmod=0700
chown=root:root

[rpcinterface:supervisor]
supervisor.rpcinterface_factory=supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock

[include]
files = /etc/supervisord.d/*.ini
EOF

# >> Run SupervisorD:
echo "[entrypoint] starting supervisord..."
exec supervisord -n -c /etc/supervisord.conf
