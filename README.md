# Docker PPTP server

### Подготовка

Для начало работы нужно узнать интерфейс шлюза по умолчанию

*Команда для **Ubuntu 20.04***

    ip route show default | awk '{print $5}'

Для использования Docker Compose укажите имя интерфейса в файле **.env** в параметре **ENV_GATEWAY_INTERFACE**

------------

### Добавления/изменения пользователей

Для добавления/изменения пользователей отредактируйте файл **pptpd/chap-secrets**

------------

### Работа с Docker Compose

Первый запуск

    docker-compose up -d --build

Перезагрузка для применения изменений

    docker-compose restart

Остановка

    docker-compose down

------------

### Работа с Docker

Создание образа

    docker build -t server_pptp .

Запуск образа

    docker run -d -e ENV_GATEWAY_INTERFACE=[интерфейс шлюза по умолчанию] --restart always --privileged --net=host server_pptp
