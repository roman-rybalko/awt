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

Установка новой ноды сервера
----------------------------
1. server_sys.sh (cert nginx munin php rsync)
2. apt-get install mysql (задать пароль root из hosts/*/passwords)
3. server_mysql.sh (mysql awt_db_backup)
4. server_slave.sh (www_repl awt_cron_del mysql_slave_1 mysql_slave_2)
5. исправить munin_node, везде переставить munin_node
6. hosts.sh
7. munin_backup.sh, munin_restore.sh
8. перенести .mysql_history, .bash_history

Master -> Slave
---------------
1. reboot.sh
2. apt-get --purge remove mysql-common, rm -Rf /etc/mysql /var/lib/mysql
3. goto `Установка новой ноды сервера` п.2

Установка нового сервиса
------------------------
1. task_types.sql
2. Зарегистрировать пустой логин и ввести сложный пароль
3. Добавить demo_subscription(.sql) для демо-логина
4. Выставить undeletable в settings для демо-логина
