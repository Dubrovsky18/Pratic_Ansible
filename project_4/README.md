 # Курс "Основы работы с сетевыми операционными системами"

# Список заданий
- [X] На серверах rrobin, web1, web2 установить nginx.
- [X] На серверах web1, web2 Nginx должен работать по порту 8080 и отдавать кастомную страницу, зайдя на которую можно понять на каком сервере вы находитесь.
- [X] На сервере rrobin Nginx должен обеспечить балансировку нагрузки серверов web1 и web2 в режиме round-robin. Вес каждого сервера одинаковый.
- [X] Установка и настройка всего ПО должна быть обеспечена Ansible-сценарием.
- [x] Все файлы по этому заданию выложить в Github и написать ReadMe со скринами работоспособности и инструкцию по запуску вашего Ansible-сценария
![Alt text](https://github.com/Dubrovsky18/OS_system/blob/main/project_4/report/web.jpg "Task")

Решение задачи
---------------------------
+ Скачаем все необходимые данные. Открывает Vagrantfile и ставим нужные machine и ip, который принадлежит каждому серверу.
![Alt text](https://github.com/Dubrovsky18/OS_system/blob/main/project_4/report/vagrantfile.png "Vagrantfile")
+ Открываем и редактируем inventory-чтобы ansible мог управлять нашими хостами.
+ Открываем и редактириуем ansible.cfg-чтобы указать наш inventory файл со всеми нужными нам параметрами(более подробно [ansible documention](https://docs.ansible.com/ansible/2.6/reference_appendices/config.html)
+ Создаем папку(roles) где будут хранится все playbooks и конифуграции для наших webservers и backend-server.
    - Папка с конфигурацей backend-server: sec_role
        * Создаем папку tasks, а в ней playbook, который будет стянет и скачает все необходимые пакеты: epel-release, nginx. Указываем путь куда установить ginx.conf и перезапускаем его.
        * Создаем папку templates, где будет хранится необходимая конфигурация для nginx - nginx.conf.j2(указываем разрешение j2, так как у нас несколько серверов, и делаем присваивание через цикл)
        * Создадим папку vars, где будут хранится все переменные которые испольюзуются во многих файлах и могут изменится при необходимости. Тем самым мы автоматизируем весь процесс. 
    - Папка с конфигурациями webservers: web_nginx
        * Cоздаем папку tasks, а в ней playbook, который будет стянет и скачает все необходимые пакеты: epel-release, nginx. Указываем путь куда установить nginx.conf и перезапускаем его. При желании можно указать и установить index.html.j2
        * Создаем папку templates, где будет хранится необходимая конфигурация для nginx - nginx.conf
        * Создадим папку vars, где будут хранится все переменные которые испольюзуются во многих файлах и могут изменится при необходимости. Тем самым мы автоматизируем весь процесс. 
+ Запускаем playbook.yml, в котором прописано к каким hosts принадлежат папки
+ Заходим в браузер. Забиваем адреса, которые мы указывали в inventory - webserver и порт, который указывали в vars. Если они показываю сайт, то круто.

Pictures
--------------------------

![Alt text](https://github.com/Dubrovsky18/OS_system/blob/main/project_4/report/web1.png "сайт на web1")
![Alt-текст](https://github.com/Dubrovsky18/OS_system/blob/main/project_4/report/web2.png "Сайт на web2")
--------------------------

+ Забиваем адрес - backend-server. Если при каждому обновлении он показывает сайт web1, а потом web2, поочередно, следовательно мы сделали все правильно, и можем отдохнуть.

Pictures
-------------------------

![Alt-текст](https://github.com/Dubrovsky18/OS_system/blob/main/project_4/report/rrobin_web1.png "Web1 in rrobin")
![Alt-текст](https://github.com/Dubrovsky18/OS_system/blob/main/project_4/report/rrobin_web2.png "Web2 in rrobin")
---------------------------
