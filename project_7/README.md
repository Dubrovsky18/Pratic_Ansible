 # Курс "Основы работы с сетевыми операционными системами"

# Список заданий
- [X] Настроить консул ( использовать уже готовую роль и инветори).
- [X] База данных должна быть проинициализирована на выделенных дисках (в Vargrantfile они уже подключены). БД должна находить в папке /pgsql/pg_data/14. WAL архивы должны находить в папке /pgsql/pg_wal/14. В эти папки должны быть примонтированы диски /dev/sdb и /dev/sdc соответственно. Диски должны быть подключены в LVM и отформатированы в файловой системе xfs.
- [X] На серверах pg1 и pg2 настроить оркестратор репликации Patroni (пакет в архиве).
- [X] С помощью утилиты vip-manager обеспечить настройку VIP адреса на мастер сервере. [vip-manager](https://github.com/cybertec-postgresql/vip-manager/releases/download/v1.0.2/vip-manager-1.0.2-1.x86_64.rpm). Напоминаю, что в конфиге vip-manager необходимо настроить подключение по DCS Consul. IP адрес подключения 127.0.0.1:8500. Так же нужно будет указать consul_token, переменную которого можно взять в роли consul

Решение задачи
---------------------------
+ Проверяем Vagrantfile и исправляем данные, которые нам необходимы
+ Запускаем Vagrantfile. После его завершения запускаем consul.play.
```
#Start Vagrantfile
vagrant up

# Start consul.play
ansible-playbook consul.play
```
+ Открываем и редактируем hosts(inventory)-чтобы ansible мог управлять нашими хостами.
+ Открываем и редактириуем ansible.cfg-чтобы указать наш inventory файл со всеми нужными нам параметрами(более подробно [ansible documention](https://docs.ansible.com/ansible/2.6/reference_appendices/config.html))
+ Создаем папку(roles) где будут хранится все playbooks и конифуграции для наших clients.
    - Папка с конфигурацей backend-server: server
        * Создаем папку handlers, а в ней playbook, на который мы будем иногда обращаться - чтобы перезагрузить postgresql
        * Создаем папку tasks, а в ней playbook, который будет стянет и скачает все необходимые пакеты: vip-manager, patroni. Указываем путь куда установить конфигурацию для postgresql и vip-manager и запускаем все необходимое.
        * Создаем папку templates, где будет хранится необходимая конфигурация для postgresql - postgrsql.yml и для vip-manager - vip-manager.yml. Environment - нам пригодится для проверки нашего задания, чтобы не писать полный путь, а прописывать только (patronictl list)
        * Создадим папку vars, где будут хранится все переменные которые испольюзуются во многих файлах и могут изменится при необходимости. Тем самым мы автоматизируем весь процесс. В нашем случае у нас будут переменные: порты для прослушивания и для подключения postgresql.
+ Запускаем playbook.yml, в котором прописано к каким hosts принадлежат папки
```
ansible-playbook playbook.yml
```
+ Заходим на один из clients:
    - Проверяем наших лидера и реплику
    ```
        watch patronictl list
    ```
    ![Alt-text](https://github.com/Dubrovsky18/OS_system/blob/main/project_7/report/lead2_sync1.png "Testing")
    - После того как мы увидили такую картину, можем прописать
    ```
    # меняем нашего лидера
    patronictl switchover

    # смотрим и ждем, когда поменяется лидер
    watch patronictl list
    ```
![Alt-text](https://github.com/Dubrovsky18/OS_system/blob/main/project_7/report/stop2_run1.png "Testing")
![Alt-text](https://github.com/Dubrovsky18/OS_system/blob/main/project_7/report/lead1_rep2.png "Testing")
![Alt-text](https://github.com/Dubrovsky18/OS_system/blob/main/project_7/report/lead1_sync2.png "Testing")
+ Если у нас все получилось, то мы молодцы и можем пойти попить чаю
