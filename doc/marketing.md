Материалы по Маркетингу
=======================

Маркетинговые истории
---------------------

### Поход в поликлинику

Как-то я захожу на сайт поликлиники записаться на прием к врачу.
А там не работает форма, ошибка какая-то.
Ну, думаю, ладно, увидят - исправят.
Через 2 недели захожу на сайт снова записаться на повторный прием.
А там та-же ошибка. Контакты администратора были не далеко,
я не поленился и сообщил об ошибке электронной почтой.
И мне тут-же ответил человек - проблема была устранена.

А сколько еще организаций, у которых на сайте сломан функционал и они об этом не знают?

### Поиск работы

Нашел интересную вакансию на сайте рекрутинговой компании, дай-ка отправлю резюме.
А резюме не отправляется - ошибка при отправке формы на сервер.
Попробовал несколько раз, огорчился и ушел.
Работу я себе конечно нашел. А рекрутер - увы, без работы.

Проблема сапожника без сапог: рекрутер врядли пользуется своим сайтом для поиска работы,
а сотрудникам, которым пользуются, им уже все равно :)

### Фишинг на сайте

Как-то клиенту понадобился новый IP-адрес. Попросили у провайдера, он выдал.
Добавили этот адрес в кластер к веб-сайту.
И вдруг некоторые пользователи стали жаловаться, что яко-бы фишинг на сайте появился.
А у клиента все работает нормально и у большинства пользователей все нормально.
Браузеры все свежие.

Странно. Сайт всегда работал без проблем, да и нет смысла в этом фишинге - пароли на сайте не вводятся.

Оказалось, что новый IP-адрес, который выдал провайдер, занесен в блок-лист РосКомНадзора!
Каламбур в том, что ни провайдер, ни клиент этот список не проверяют.
Раньше адрес видимо принадлежал кому-то еще, от этого адреса отказались и теперь адрес отдали снова.
А проверяет этот список ТрансТелеком, континентальный провайдер, который тянет кабеля по всей России.
И иногда получается, что маршрут к клиентскому серверу проходит через ТрансТелеком,
а ТрансТелеком показывает пользователю страницу о блокировке сайта,
которая выглядит как предупреждение браузера о фишинге.

Нужно смотрель на свой сайт со всех сторон.
С каждым годом в Сети образуется все больше факторов, которые влияют на функциональность вашего сайта.

### Письменный и Электронный документооборот

#### Мотивация
Следует отдавать предпочтение ЭДО.
Письменные формы приводят к задержкам в принятии решений, создают дополнительные накладные расходы, снижают возможности автоматизации.

#### Письменный договор
Письменный договор приобретает юридическую силу только после экспертизы.

Письменный договор подвержен фальсификации. Возможно использовать другую печать (не существует реестра печатей, где можно проверить достоверность оттиска). Возможно поставить недостоверную подпись.

#### Пример
Банковские переводы осуществляются через посредника (корреспондентский счет).
Если бы банки производили переводы напрямую, у них бы возникали двухсторонние отношения.
Разрешение споров в таких отношениях имеет сложности, т.к. участники имеют равноправные позиции (один утверждает, что деньги отправил, а другой утверждает, что ничего не получил).
Ускорить решение двусторонних вопросов позволяет привлечение третьего участника, свидетеля.
По этому банковские переводы осуществляются через третий банк, банк-посредник.
В России роль посредника выполняет ЦБ, в системе международных переводов SWIFT все банки равнозначны и посредник выбирается произвольно среди остальных банков.
Банк-посредник поддерживает корреспондентский счет и выступает в роли свидетеля.

#### ЭДО
Оператор ЭДО выступает в роли посредника. Он является свидетелем заключения сделки. Он обладает нотариальными полномочиями.
В случае необходимости у оператора ЭДО можно запросить нотариально заверенную копию договора со всеми датами (отправки, получения).

#### Вывод
ЭДО или устные договоренности с оплатой наличными средствами.
В письменной форме нет никакого смысла.

Если у клиента еще не настроен ЭДО - пускай настраивает и осваивает его вместе с нами, мы проконсультируем, это имеет для нас косвенную выгоду.

### Карма
Как-то наш аналитик приступил к изучению сайта одной крупной IT-компании.
Он обнаружил пару ошибок, и когда он принялся составлять тест-план
на сайте рухнул бэкэнд! Т.е. получили 502 Bad Gateway.
Самое интересное - в таком состоянии сайт простоял все выходные!
И это довольно крупная организация, таких в России не более десятка.

Говорят, есть разные виды багов https://habrahabr.ru/post/104952/
Гейзенбаг, Борбаг, Мандельбаг, Шрединбаг, Фаза луны и т.д.
Но на самом деле суть не в багах а в людях.
Баги одним людям показываются а другие люди их не встречают никогда.
Этот феномен называется Карма.

У нас работают специализированные люди со специализированной кармой,
которые способны выявить любые виды багов.
И даже те баги, которые никогда не проявляются.
Вы должны понимать, что если баг не проявляется,
это не значит что его нет.
Возможно этот баг поджидает вашего самого лучшего клиента.