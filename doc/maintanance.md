Обслуживание (Регламенты)
=========================

* Проверять лог веб-сервера (var/log/nginx/error.log) на ошибки php.
* Проверять почту от www-data (ошибки из cron).
* Проверять bounce для Task Report и удалять адреса.

Failover
--------
*(восстановление после сбоя основной ноды клсатера)*

1. Изменить DNS (advancedwebtesting A & AAAA -> другая нода)
2. STOP SLAVE (mysql)
3. Включить cron.php (* * * * * cd /var/www/awt && php cron.php)
4. service rsync start
5. Переустановить основную ноду в slave
