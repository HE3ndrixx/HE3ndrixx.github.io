#!/bin/bash

cd /usr/bin
wget https://github.com/geovpn/geovpn.github.io/raw/main/ssh/ws-epro
chmod +x /usr/bin/ws-epro
cd

cat > /etc/systemd/system/salomessh.service << END 
[Unit]
Description=ws-epro

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/ws-epro -salome -listen :443 -ssh 127.0.0.1:22 -ssl 127.0.0.1:8443
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable salomessh.service
systemctl start salomessh.service
