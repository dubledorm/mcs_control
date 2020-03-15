# README

Административная панель для управления большим количеством специализированных сервисов размещённых в облаке.
Построена на базе ActiveAdmin.
Предоставляет функции администрирования и мониторинга.

Основной функционал:

* Подключать новые сервисы, создавать и подключать базы данных для них, создавать пльзователей БД, настраивать сетвые ресурсы (nginx) для доступа к новым сервисам. 

* Выделять дополнительные ресурсы для сервисов, а именно порты nginx, автоматически переконфигурировать и перезапускать nginx для подхвата новых конфигураций.

* Предоставлять мониторинг tcp соединений с использованием других микросервисов. Перехватывать передаваемые данные и перенаправлять их на служебные порты. С помощью механизма websocket отображать эти данные online в web интерфейсе пользователя.

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
