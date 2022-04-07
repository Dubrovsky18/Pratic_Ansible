 # Курс "Основы работы с сетевыми операционными системами"

# Список заданий
- [X] На серверах web1, web2 установить Nginx.
- [X] На серверах haproxy1, haproxy2 установить и настроить  отказоустойчивую связку HAProxy+Keepalived. Настроить VIP с помощью Keepalived в соответствии со схемой
- [X] На серверах web1, web2 Nginx должен работать по порту 8080 и отдавать кастомную страницу, зайдя на которую можно понять на каком сервере вы находитесь.
- [X] На серверах с HAProxy ПО должно обеспечить балансировку нагрузки серверов web1 и web2 в режиме round-robin. Сделать таймауты ожидания ответа web1 и web2 как можно меньше. Скажем, 1-2 секунды
- [X] Установка и настройка всего ПО должна быть обеспечена Ansible-сценарием.
- [X] Все файлы по этому заданию выложить в Github и написать ReadMe со скринами работоспособности и инструкцию по запуску вашего Ansible-сценария

![Alt text](https://github.com/Dubrovsky18/OS_system/blob/main/project_5/report/task.jpg "Task")

Решение задачи
---------------------------
+ Скачаем все необходимые данные. Открывает Vagrantfile и ставим нужные machine и ip, который принадлежит каждому серверу.
+ Открываем и редактируем inventory-чтобы ansible мог управлять нашими хостами.
+ Открываем и редактириуем ansible.cfg-чтобы указать наш inventory файл со всеми нужными нам параметрами(более подробно [ansible documention](https://docs.ansible.com/ansible/2.6/reference_appendices/config.html))
+ Создаем папку(roles) где будут хранится все playbooks и конифуграции для наших webservers и backend-servers.
    - Папка с конфигурацей backend-server: lb_role
        * Создаем папку handlers, а в ней playbook, на который мы будем иногда обращаться - чтобы перезагрузить keepalived и haproxys
        * Создаем папку tasks, а в ней playbook, который будет стянет и скачает все необходимые пакеты: haproxy, keepalived. Указываем путь куда установить конфигурацию для haproxy и keepalived и перезапускаем их.
        * Создаем папку templates, где будет хранится необходимая конфигурация для haproxy - haproxy.cfg.j2(указываем разрешение j2, так как у нас несколько серверов, и делаем присваивание через цикл) и для keepalived - keepalived.conf.j2(указываем разные приоритеты)
        * Создадим папку vars, где будут хранится все переменные которые испольюзуются во многих файлах и могут изменится при необходимости. Тем самым мы автоматизируем весь процесс. В нашем случае у нас будут переменные: порты web-servers и значения для bind в keepalived(backen-servers)
    - Папка с конфигурациями webservers: webserver_role
        * Cоздаем папку handlers, а в ней playbook, на который мы будем иногда обращаться - чтобы перезагрузить nginx
        * Cоздаем папку tasks, а в ней playbook, который будет стянет и скачает все необходимые пакеты: epel-release, nginx. Указываем путь куда установить nginx.conf и перезапускаем его. При желании можно указать и установить index.html.j2
        * Создаем папку templates, где будет хранится необходимая конфигурация для nginx - nginx.conf
        * Создадим папку vars, где будут хранится все переменные которые испольюзуются во многих файлах и могут изменится при необходимости. Тем самым мы автоматизируем весь процесс. 
+ Запускаем playbook.yml, в котором прописано к каким hosts принадлежат папки
+ Заходим в браузер. Забиваем адреса, которые мы указывали в inventory - webserver и порт, который указывали в vars. Если они показываю сайт, то круто.


\
--------------------------

![Alt text](https://github.com/Dubrovsky18/OS_system/blob/main/project_5/report/web1.png "сайт на web1")
![Alt-текст](https://github.com/Dubrovsky18/OS_system/blob/main/project_5/report/web2.png "Сайт на web2")
--------------------------

+ Забиваем адрес - Virtual IP([Немного о Keepalived и VI](https://www.servers.ru/knowledge/linux-administration/how-to-setup-floating-ip-using-keepalived)). Если при каждом обновлении он показывает сайт web1, а потом web2, поочередно, следовательно мы сделали все правильно.

\
-------------------------

![Alt-текст](https://github.com/Dubrovsky18/OS_system/blob/main/project_5/report/haproxy_web1.png "Web1 in haproxy")
![Alt-текст](https://github.com/Dubrovsky18/OS_system/blob/main/project_5/report/haproxy_web2.png "Web2 in haproxy")
---------------------------


### Проверка на отказоустойчивость
==================================

+ Выключаем один из backend-server(желательно, чей приоритет выше). Забиваем адрес - Virtual IP. Если при каждом обновлении он показывает сайт web1, а потом web2, поочередно, следовательно мы сделали все правильно.

\
---------------------
![Alt-текст](https://github.com/Dubrovsky18/OS_system/blob/main/project_5/report/failover/haproxy1_web1.png "Отказоустойчивасть. Web1 - Основа на haproxy1")
![Alt-текст](https://github.com/Dubrovsky18/OS_system/blob/main/project_5/report/failover/haproxy1_web2.png "Отказоустойчивасть. Web2 - Основа на haproxy1")
---------------------------



+ Включаем один сервер, выключаем другой. Забиваем - Virtual IP.Если при каждом обновлении он показывает сайт web1, а потом web2, поочередно, следовательно мы сделали все правильно.

\
---------------------
![Alt-текст](https://github.com/Dubrovsky18/OS_system/blob/main/project_5/report/failover/haproxy2_web1.png "Отказоустойчивасть. Web1 - Основа на haproxy2")
![Alt-текст](https://github.com/Dubrovsky18/OS_system/blob/main/project_5/report/failover/haproxy2_web2.png "Отказоустойчивасть. Web2 - Основа на haproxy2")
---------------------------