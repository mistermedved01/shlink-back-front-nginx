#!/bin/bash

wget https://github.com/shlinkio/shlink-web-client/releases/download/v4.3.0/shlink-web-client_4.3.0_dist.zip
unzip shlink-web-client_4.3.0_dist.zip
mv shlink-web-client_4.3.0_dist shlink_front
mv shlink_front /var/www/
chown -R www-data:www-data /var/www/shlink_front
chmod -R 755 /var/www/shlink_front

# Генерация API-ключа
API_KEY=$(sudo -u www-data php8.3 /var/www/shlink_back/bin/cli api-key:generate | awk -F'"' '/Generated API key/ {print $2}')
echo "Новый ключ: $API_KEY"

# Запись JSON в файл
cat <<EOF > /var/www/shlink_front/servers.json
[
  {
    "name": "Main server",
    "url": "http://192.168.1.103:81/shlink",
    "apiKey": "$API_KEY"
  }
]
EOF

echo "server {
    listen 80 default_server;
#    server_name shlink.short;
    charset utf-8;
    root /var/www/shlink_front/;
    index index.html;

    # Проксирование API
    location /shlink/ {
        proxy_pass http://127.0.0.1:81;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # CORS настройки
    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
    add_header Access-Control-Allow-Headers 'Authorization, Content-Type, X-Requested-With';

    # Основной маршрут
    location / {
        try_files \$uri \$uri/ /index.html\$is_args\$args;
    }

    # Expire rules
    location ~* \.(?:manifest|appcache|html?|xml|json)$ {
        expires -1;
    }

    location ~* \.(?:jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm|htc)$ {
        expires 1M;
        add_header Cache-Control public;
    }

    location ~* \.(?:css|js)$ {
        expires 1y;
        add_header Cache-Control public;
    }

    location = /servers.json {
        try_files /servers.json /conf.d/servers.json;
    }

    location ~* .+\.(css|js|html|png|jpe?g|gif|bmp|ico|json|csv|otf|eot|svg|svgz|ttf|woff|woff2|ijmap|pdf|tif|map)$ {
        try_files \$uri \$uri/ =404;
    }
}" > /etc/nginx/sites-available/shlink_front.conf

ln -s /etc/nginx/sites-available/shlink_front.conf /etc/nginx/sites-enabled/
systemctl restart nginx