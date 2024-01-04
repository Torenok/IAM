# Работа с сервисами IAM

# Репозиторий с файлами

---

[https://github.com/Torenok/IAM](https://github.com/Torenok/IAM)

# Yandex Cloud

---

Была создана организация + к ней был прикреплен Billing Account. 

В организации было создано новое облако.  

Для управления ресурсами был создан отдельный сервисный пользователь (svc-terraform).  

![image](https://github.com/Torenok/IAM/assets/63847050/567e780a-16e4-4fff-8486-3c75eaa1c5fa)
![image](https://github.com/Torenok/IAM/assets/63847050/7f74e4df-00cf-4620-b435-e5e11d03b163)
![image](https://github.com/Torenok/IAM/assets/63847050/5eff826e-7393-4f22-8302-0836330c8652)


Далее с помощью Terraform были реализованы след операции:

1. Было создано 2 каталога, в которых будем размещать бакеты
    1. privates3-folder
    2. publics3-folder
    
![image](https://github.com/Torenok/IAM/assets/63847050/3845c480-a08b-4eea-9879-eed573ca2863)

    
2. Было создано 2 сервисных аккаунта:
    1. sa-privates3
    2. sa-publics3
    
![image](https://github.com/Torenok/IAM/assets/63847050/c5904305-533c-412f-b35e-217b442999f1)

    
3. Было создано 2 группы:
    1. s3-private-group
    2. s3-public-group
    
![image](https://github.com/Torenok/IAM/assets/63847050/0555e943-f0c2-4482-8436-42ed9ada4d93)

    
4. В каждом каталоге был создан отдельный бакет
    1. bucket-private-7jna3vwm
    2. bucket-public-7jna3vwm
    
![image](https://github.com/Torenok/IAM/assets/63847050/bde225b0-bbe1-45b1-af8a-f05c4fe2ec33)

    
5. Для каждого бакета были настроены права доступа в соответствии со след правилами:
    1. на бакет **bucket-public-7jna3vwm** выданы права **storage.uploader** для групп:
        1. s3-private-group
        2. s3-public-group
    2. на бакет **bucket-private-7jna3vwm** выданы права **storage.uploader** группы s3-private-group
    3. на бакет **bucket-private-7jna3vwm** выданы права **storage.viewer** группы s3-public-group
    
![image](https://github.com/Torenok/IAM/assets/63847050/3cec9705-a3ef-4e91-abee-5f72f0ed265c)

