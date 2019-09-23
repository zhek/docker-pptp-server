# Docker PPTP server

### Работа с Docker Compose

Первый запуск

    docker-compose up -d --build

Для добавления/изменения пользователей отредактируйте файл **pptpd/chap-secrets**

Перезагрузка для применения изменений

    docker-compose restart

Остановка

    docker-compose down

------------

### Работа с Docker

Создание образа

    docker build -t server_pptp .

Запуск образа

    docker run -d --restart --privileged --net=host server_pptp