Концепция
=========
* User.
* Регистрация.
* Тесты, Планировщик, Финансы.
* Контакты (для уведомлений: e-mail, sms, jabber).
* На хосте может быть несколько модулей node. Каждый находится в отдельном пользователе.
* Статистика агрегируется по часам. В идеале выбрать максимальный интервал, например по дням, но в разных временных зонах день начинается в разное время.
* Статистика удаляется после 42 дней. Максимальное количество записей - 1008 (42*24) - приемлемо.
* Код выносить в отдельные функции/модули только для устранения дублирования.
* Денег брать по рублю за Test Action. Можно и по центу, но лучше по рублю, т.к. рубль дороже а выглядит дешевле.
* При блокировании аккаунта:
 1. изенить пароль на случайный
 2. изменить логин на случайный
 3. удалить E-Mail (если есть)
 4. удалить все задачи расписания
 5. отменить все подписки и транзакции в биллинге
 6. сделать refund по размеру баланса
 6. списать остаток баланса (для последующего удаления аккаунта из БД, после полного refund остаток содержит только бонусы)
 7. отменить все задачи в очереди на выполнение
 8. удалить тесты (пометить как удаленные, для удаления аккаунта когда они зачистятся из БД)
* Основной код лежит в каталогах advanced_web_testing и web_construction_set, из ai/ ui/ si/ он вызывается. Это упрощает обновления.
* Таймаут для теста и test action. Если тест выполняется более таймаута то он перезапускается. Тест в состоянии выполнения
 можно отменить после суммы таймаутов для test action. Отдельный таймаут для каждого теста не эффективно (нужно будет регулярно перебирать
 все тесты). По этому возникает максимальное количество test action.
* Именование хостов:  
sX.hosts.advancedwebtesting.com - сеовер (веб-интерфейс)  
cX.hosts.advancedwebtesting.com - клиент (task executor)  
pX.hosts.advancedwebtesting.com - прокси  
nX.hosts.advancedwebtesting.com - general-purpose node  

Удаление неиспользуемых аккаунтов
---------------------------------
*Задача*  
Нужно удалять неиспользуемые аккаунты, читать из БД минимально, доп. SQL (limit, count) не использовать.

Удалять аккаунт с тестами нельзя - пользователь мог пополнить аккаунт и уйти на пол года.
В этом случае как только баланс исчерпается аккаунт сразу-же будет удален.
Только отсутствие транзакций биллинга позволяет выявить неактивность аккаунта.
Но регулярная (каждую минуту из cron) выборка транзакций билинга нарушает условия задачи по работе с БД.

*Решение*  
Добавить time в users.
Поле time - время доступа (login, ch.password).
Удалить данные users если (выполнение всех условий):
* users.time старше purge period
* аккант возможно удалить (undeletable != 1)
* нет E-mail
* нет тестов
* баланс <= 0
* отсутствуют pending transactions
* отсутствуют subscriptions

При выполнении этих условий других данных в системе уже нет (кроме билинга).
Могут остаться транзакции биллинга, но они невозвратные (purge period занесен в terms по возвратам).
stats, tasks, history к этому моменту удалятся (они удаляются с тем-же периодом).
Количество Pending Transactions и Subscriptions невелико, регулярное их вычитывание условия работы с БД не нарушает.

*Проблема*  
Что если есть тесты но аккаунт не используется?

*Решение*  
Смотреть наличие транзакций биллинга, но это нарушает условия работы с БД.

*Другое решение*  
Удалять аккаунты вручную если нет с них дохода.
Вручную проверять наличие транзакций биллинга (это гораздо реже чем из cron).

Вероятно имеет смысл применить оба решения.

Репликация
----------
*Цели* (в порядке убывания приоритета):
1. Кластер
2. Горячий резерв
3. Холодный резерв
4. Бэкап

Для бэкапа требуется копировать не только БД но и набор файлов (картинки), объем данных на данный момент более 10Гб.
Сложность реализации сопоставима с холодным резервом.

Для реализации *кластера* нужно решить следующие проблемы:  
1. Репликация БД мастер-мастер
2. Синхронное изменение БД обеих нод
3. Репликация файлов мастер-мастер
4. Общие сессии php для обеих нод

Репликация БД мастер-мастер решаема, но будет присутствовать лаг, который будет усиливаться с увеличением нагрузки.
Есть возможность вносить изменения синхронно, но снизится производительность изменений и вообще утратится резервирование
т.к. при отказе одной из нод оставшаяся будет находиться в таймауте.  
Есть проблема с репликацией удаленных файлов. Реплицировать новые файлы не сложно.
Проблема с восстановлением удаляемых файлов пока не решена (данные нужно удалить а они восстанавливаются с соседней ноды).  
Общие сессии возможно реализовать используя session_set_save_handler(). Хранить данные в БД либо локально с синхронизацией
на другую ноду собственной реализацией (например, по HTTP).  
Возможно производить изменения только на одной ноде и проксировать запросы с другой ноды, но в этому случае так-же утратится резервирование.
Вывод: сложность реализации кластера выше допустимой для проекта (для проекта допустимым выбран минимально возможный уровень сложности).

*Горячий резерв*:  
Полностью такой-же сервер как и основной. DNS в штатном режиме указывает на основной сервер.
Обычная репликация master-slave.
Репликация файлов: rsync из cron.
cron.php отключен.

Автоматическое построение XPATH
-------------------------------

### Подбор (guess)
Подбор параметров XPATH для автоматического добавления (где отсутствует связь со страницей).

Для гарантированно точного XPATH выбиаем теги все подряд (кроме html и body) и выставляем на них индексы.
В последнем теге включаем один из атрибутов @id`/`@name`/`@type`/`@role`.

### Оптимизация
Минимизация XPATH, устранение лишних тегов и предикатов (при наличии связи со страницей).

Общий алгоритм: изменение -> проверка -> изменение -> проверка ...  
Есть стратегии для ситуаций:
1. Последний тег отключен (он может быть отключен пользователем).  
 Включаем последний тег. Очищаем состояние и перезапускаем алгоритм.
2. Элементы не найдены или ошибка.  
 Удаление предикатов и тегов от корня. Удаляем предикаты, удаляем тег, предикаты, тег... пока не найдутся элементы - переходим к п.3.
 Если удалили все - выход.
3. Найден 1 элемент.  
 Удаление предикатов и тегов от корня.
 Последний тег оставляем (его отсутствие может создать более оптимальный но неверный xpath).
 Если после изменения результат ухудшился - откат и следующее изменение.
 Ухудшение результата = количество найденных элементов != 1 или ошибка.
4. Найдено больше 1 элементов.  
 Добавляем предикаты и теги от хвоста к корню, пока не найдется только 1 элемент - переходим к п.2.
 Если после изменения результат ухудшился - откат и следующее изменение.
 Ухудшение результата = элементы не найдены или ошибка.
 Если добавили все - выход.

Т.к. все индексы заданы относительно родителя (на данный момент они вычисляются сервисным скриптом относительно родителя),
во всех стратегиях нужно влючать предикаты индексов совмесно с родителем
(включаем индекс - включаем родителя, отключаем индекс - можем отключить родителя, отключаем тег - отключаем индекс дочернего).

Предлагается применить конечный автомат.
На вход поступает количество найденных элементов и состояние.
На выходе изменение в выборке предикатов XPATH.

Распределенное хранение скриншотов
----------------------------------
Файлы скриншотов results/.../... - это основные данные на дисках серверов sX.
Однако скриншоты востребованы не часто. Часть скриншотов возможно хранить на других серверах,
реплицировать (rsync) и перенаправлять пользователя (302 Found, Moved Temporarily).
Предлагается следующая схема хранения.

Предположим s1 - основной сервер.
В nginx на s1 настроена директива try_files, которая перенаправляет (в случае отсутствия файла) на s2.
На s2 директива try_files перенаправляет на s3.
На последнем сервере sX при отсутствии файла возвращается 404 Not Found.

Файлы и каталоги на сервере s1, которые созданы неделю назад (период настраивается) переносятся на сервер s2 (bash + rsync --delete-source-files + find + rm).
С сервера s2 данные, которые старше 20 дней (период настраивается), переносятся на сервер s3.

Периоды выбираются из расчета "объем диска"/"количество actions за единицу времени".
Первый сервер будет иметь диск значительно меньше и быстрее, чем остальные, по этому время хранения на первом сервере
будет минимально (1-2 дня, максимум 7 дней). В общем случае у серверов будут разные диски и разное время хранения.

Из php файлы не удаляются, только очищается БД.

[Task Types](task_types.md)  
[Action Types](action_types.md)  
[Обслуживание](maintanance.md)  
