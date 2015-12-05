План
====
2. В ui снизу сделать область аналогично как сверху, со ссылкой на support. Сейчас нет ссылок на support.
3. ie7, ie8, ie9: virtualbox + win2k3srv + rdesktop
4. административный интерфейс - статистика, мониторинг
5. cleanup (stats, tasks, billing, accounts - see concept)
6. cron: clear canceled tasks
7. cron: clear deleted tests
8. cron: clear finished tasks
9. cron: clear deleted tests
10. cron: clear history
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
