План
====
28. Написать мануал для каждого типа action
1. ad idea: перетаскивать людей ищущих web monitoring software
1. ad idea: free site monitoring - и завести в демо-аккаунт
1. ad idea: c# perl python for web automation - не надо программировать, есть готовый сервис
1. ad idea: we crawler - software/free/php-python-perl
3. ie7, ie8, ie9: virtualbox + win2k3srv + rdesktop
4. административный интерфейс - статистика, мониторинг
11. XPATH Browser в iframe/отдельном окне, с/без прокси (пользователь сам подгружает скрипт, Tip: Browser plugin)
12. XPATH -> jQuery/CSS3 selector translator
13. XMPP Reports
14. SMS Reports
15. Отдельный раздел и таблица notifications, каждая notification содержит параметры: email/телефон/jid. Каждый Schedule Job содержит
 набор нотификаций для успеха и сбоя. Каждый Task содержит sched_id и sched_name или null если запущен вручную. Settings как-то
 переработать - убрать галки отправки отчетов. Дефолтный набор нотификаций не делать. Возможность скопировать Schedule Job.
 Восстановление пароля и платежная информация только на E-Mail из Settings.
16. php openssl_sign bug report
17. php xsltprocessor recursion bug report
18. доработать wine для запуска Selenium IEDriverServer
19. action: label, condition (test an expression & skip to the label) - for captcha bypass
20. action: save element image into var - for captcha bypass
21. action: open a new window/tab or change open behavior - for captcha bypass
22. action selectors: xpath: & jquery: (by default xpath)
23. Валидация добавляемых actions
24. В Tasks сделать status числовым (ускорить xslt)
25. Рефакторинг Task\Manager - перенести Type\Manager в поле класса
26. Client selenium_open_timeout - отдельный таймаут для "open" Action
29. Решить проблему перерасхода памяти в billing_archive (PHP Fatal error: Allowed memory size of 134217728 bytes exhausted
 (tried to allocate 72 bytes) in /var/www/awt/web_construction_set/database/relational/billing.php on line 128)
