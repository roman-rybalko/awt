Обслуживание (Регламенты)
=========================

* Проверять лог веб-сервера (var/log/nginx/error.log) на ошибки php.
* Проверять почту от www-data (ошибки из cron).
* Проверять bounce для Task Report и удалять адреса.

Failover
--------
*Восстановление после сбоя или вывод основной ноды из эксплуатации.*

### Регламент
1. Выполнить на *старой ноде* `deploy/batch/server_failover.sh` (nnn_failover_iptables nnn_awt_cron_del), параметры: IP4 IP6 *новой ноды*.
2. Выполнить `scripts/server/yandex_dns_bulk.php`, параметры: A AAAA *новой ноды*.
3. Выполнить на *новой ноде* `deploy/batch/server_slave2master.sh` (nnn_awt_cron nnn_www_repl_del nnn_mysql_slave2master).

#### Идея
1. Изменить DNS (advancedwebtesting A & AAAA -> другая нода)
2. STOP SLAVE (mysql)
3. Включить cron.php (* * * * * cd /var/www/awt && php cron.php)
4. service rsync start
5. Переустановить основную ноду в slave

Миграция БД
-----------
1. src: mysql_backup.sh
1. dst: mysql_slave (MYSQL_MASTER=xxx mysql mysql_slave_1 mysql_slave_2)
1. src: server_maint_mode_on.sh (awt_cron_del nginx_maint_mode_on)
2. src: mysql_stop.sh
2. dst: mysql_slave2master.sh
3. dst: mysql_proxy_master.sh (mysql_proxy_del mysql_proxy mysql_proxy_master iptables)
4. src: mysql_proxy_slave.sh (mysql_proxy_del mysql_proxy mysql_proxy_master iptables)
5. src: server_maint_mode_off.sh (awt_cron nginx_maint_mode_off)\
