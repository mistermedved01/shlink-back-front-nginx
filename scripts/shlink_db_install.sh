#!/bin/bash
apt-get update

# Установка PostgreSQL
apt-get install -y postgresql postgresql-contrib

# Переключение на пользователя postgres для настройки БД
sudo -u postgres psql -c "CREATE USER pdo_pgsql WITH PASSWORD 'password';"
sudo -u postgres psql -c "CREATE DATABASE pdo_pgsql OWNER pdo_pgsql;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE pdo_pgsql TO pdo_pgsql;"

# Разрешаем доступ всем пользователям и с любого IP
echo "host    all             all             0.0.0.0/0               trust" | sudo tee -a /etc/postgresql/16/main/pg_hba.conf

# Настраиваем PostgreSQL для прослушивания всех интерфейсов
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/16/main/postgresql.conf

# Перезапуск PostgreSQL для применения изменений
systemctl restart postgresql