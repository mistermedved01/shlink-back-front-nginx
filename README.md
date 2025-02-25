## Задача :bulb:

1. Установить **PostgreSQL** на **VM - shlink_db**
2. Развернуть **shlink backend + shlink frontend** на **VM - shlink_back_front**
3. Настроить подключение **к shlink_db**
4. Установить web-сервер nginx на **VM - nginx_reverse_proxy** и настроить проксирование запросов в **shlink_back_front**

## Установка проекта

**Требования:**
- **Vagrant** (version 2.2+)
- **VirtualBox**

**1. Клонируем репозиторий:**
```bash
git clone https://github.com/mistermedved01/shlink-back-front-nginx.git
cd shlink-back-front-nginx
```

**2. Инициализируем ВМ в Vagrant:**
```bash    
vagrant up
```

**3. Shlink веб-интерфейс доступен по адресу:**

http://192.168.1.101 
