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
2. Проверить работоспособность сайта.
3. Выполнить `scripts/server/yandex_dns_bulk.php`, параметры: A AAAA *новой ноды*.
4. Подождать 15 минут.
5. Выполнить на *старой ноде* `deploy/batch/server_failover_status.sh` (nnn_iptables_nat_status) и запомнить счетчики.
6. Зайти на сайт.
7. Выполнить на *старой ноде* `deploy/batch/server_failover_status.sh` (nnn_iptables_nat_status) и убедиться, что счетчики не изменились;
 если счетчики изменились - goto п.4; если после второй итерации счетчики продолжают изменяться - выполнить **регламент отмены**.
8. Проверить `/var/log/nginx/access.log` на *новой ноде* - запросов со *старой ноды* в логе быть не должно, если есть - goto п.4;
 после второй итерации выполнить **регламент отмены**.
8. Выполнить на *новой ноде* `deploy/batch/server_slave2master.sh` (nnn_awt_cron nnn_www_repl_del nnn_mysql_slave2master).
9. Перезагрузить *старую ноду* (для очистки iptables и файловой системы от временных и удалённых файлов).

### Регламент отмены
1. Проверить TTL для записей A и AAAA в DNS (`scripts/server/yandex_dns.php`) - оно должно быть 900 или меньше.
2. Исправить TTL для всех доменов.
3. Выполнить `scripts/server/yandex_dns_bulk.php`, параметры: A AAAA *старой ноды*.
4. Выполнить на *старой ноде* `deploy/batch/server_failover_cancel.sh` (nnn_failover_iptables/ADD=0 nnn_awt_cron), параметры: IP4 IP6 *новой ноды*.
5. Подождать 12 часов.

#### Идея
1. Изменить DNS (advancedwebtesting A & AAAA -> другая нода)
2. STOP SLAVE (mysql)
3. Включить cron.php (* * * * * cd /var/www/awt && php cron.php)
4. service rsync start
5. Переустановить основную ноду в slave
