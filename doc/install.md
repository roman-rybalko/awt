Установка
=========

Зависимости
-----------
* php5-json
* php5-mysql
* php5-xsl
* php5-gd
* php5-curl (для webmoney)
* php-pear
* php5-cli (для cron)

* xvfb
* dwm
* scrot
* jre (openjdk)
* x11vnc

* firefox
* chromium-brwser
* flashplugin-installer

Установка новой ноды
--------------------
1. server_sys.sh: cert nginx munin php rsync
2. apt-get install mysql, задать пароль root из hosts/*/passwords
3. server_mysql.sh: mysql (настроить), awt_db_backup (настроить ротацию)
4. server_slave.sh: www_repl (настроить), awt_cron_del, mysql_slave_1 (скопировать и загрузить образ бд), mysql_slave_2 (запустить репликацию)

Установка нового сервиса
------------------------
1. task_types.sql
2. Зарегистрировать пустой логин и ввести сложный пароль.
3. Добавить demo_subscription(.sql) для демо-логина.
4. Выставить undeletable в settings для демо-логина.
