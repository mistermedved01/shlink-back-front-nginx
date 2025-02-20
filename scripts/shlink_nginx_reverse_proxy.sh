#!/bin/bash
apt-get update
apt-get install -y nginx

# Настройка reverse proxy
cat <<EOF > /etc/nginx/sites-available/shlink
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    location / {
        proxy_pass http://192.168.1.103:80;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

rm -f /etc/nginx/sites-enabled/default

ln -sf /etc/nginx/sites-available/shlink /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx

echo "****************************************************"
echo "* Shlink веб-интерфейс доступен по адресу:          *"
echo "* http://192.168.1.101                             *"
echo "****************************************************"