План
====
10. административный интерфейс - статистика, мониторинг
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
27. Обфускация JavaScript в output buffer для ui-en/php/xpath-browser-composer.php (?)
28. Добавление, удаление и изменение action без перезагрузки страницы ?test=1 (?)
29. ie7, ie8, ie9: virtualbox + win2k3srv + rdesktop
33. сделать описания для кодов ошибок, оставить вывод кода ошибки и ссылку support только для внутренних ошибок
35. краулер для создания тест-плана
36. по списку сайтов автоматическоая генерация коммерческого предложения и отправка на контактный e-mail организации (?)
37. компрессия БД средствами mysql, когда размер превысит 1Gb
38. Распределенное хранение скриншотов (см. concept).
40. найти сайты где люди ищут системы, похожие на мою, и публиковать в ответах мою ссылку
41. export/import all account data (?) (аналогично adwords: сделать программулину для экспорта/импорта аккаунта,
 но не обязательно встраивать эту функция в API - есть операции import аналогичные bulk edit в adwords,
 остальные операции манипулируют единичными объектами, есть лог - позволяет восстановить случайно удаленные данные).
43. количество попыток теста для client из конфига server
44. Передавать таймаут в client из server, хранить в tests и tasks
45. Отправка e-mail нескольким получателям
46. Локализация e-mail
