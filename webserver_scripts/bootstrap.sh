 #!/bin/bash

# Unpack Resources
sudo tar xvf /srv/www/server-files.tar.gz -C /srv/www/

############################################################

# App Service Setup
echo "[Unit]
Description=lenslocked.com main

[Service]
WorkingDirectory=/srv/www/resources/
ExecStart=/srv/www/resources/main -prod
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/lenslocked.com.service

# Reload the service
sudo systemctl daemon-reload
sudo systemctl enable lenslocked.com.service

############################################################

wget https://github.com/caddyserver/caddy/releases/download/v2.0.0-rc.3/caddy_2.0.0-rc.3_linux_amd64.tar.gz -P /tmp/
sudo tar xvf /tmp/caddy_2.0.0-rc.3_linux_amd64.tar.gz -C /srv/www/

# https://github.com/caddyserver/dist/tree/master/init
# Caddy Service Setup
echo "[Unit]
Description=caddy server for serving lenslocked.com

[Service]
WorkingDirectory=/srv/www/resources/
ExecStart=/srv/www/caddy run --environ --config /srv/www/resources/Caddyfile
ExecReload=/srv/www/caddy reload --config /srv/www/resources/Caddyfile
Restart=always
RestartSec=120
LimitNOFILE=8192

[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/caddy.service


sudo systemctl daemon-reload
sudo systemctl enable caddy.service

############################################################

# Purge bootstrap file
sudo rm /tmp/bootstrap.sh

