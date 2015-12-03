Action Types
============

xpath может задавать как элемент так и атрибут.
selector и data могут содержать переменные, имя переменной задается структурой {NAME}.
В дальнейшем структуры {XXX ...} можно будет дополнить математическими и строковыми операциями.

Открыть страницу
----------------
type: open  
selector: url  

Проверить наличие на странице
-----------------------------
type: exists  
selector: xpath  

Кликнуть по элементу
--------------------
type: click  
selector: xpath  

Ввести данные в поле ввода (input)
----------------------------------
type: enter  
selector: xpath  
data: значение  

Изменить значение
-----------------
type: modify  
selector: xpath  
data: значение  

Ожидать появления URL в браузере
--------------------------------
type: url  
selector: regexp  

Ожидать появления Title в браузере
----------------------------------
type: title  
selector: regexp  

Установить переменную, применив RegExp к её значению
----------------------------------------------------
type: var_regexp  
selector: имя  
data: regexp  

Установить переменную в значение, полученное из xpath
-----------------------------------------------------
type: var_xpath  
selector: имя  
data: xpath  

Записать URL браузера в переменную
----------------------------------
type: var_url  
selector: имя  

Записать Title браузера в переменную
------------------------------------
type: var_title  
selector: имя  

Set Proxy
---------
type: proxy  
selector: name (us, fr, cn, ru, default, custom)  
data: host:port | url to file.pac | empty (disable)  
