# Работа с сервисами IAM

# Репозиторий с файлами

---

[https://github.com/Torenok/IAM](https://github.com/Torenok/IAM)

# Yandex Cloud

---

Была создана организация + к ней был прикреплен Billing Account. 

В организации было создано новое облако.  

Для управления ресурсами был создан отдельный сервисный пользователь (svc-terraform).  

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/38bf76e7-2f5e-470f-b7c6-585505104904/58f2ee7f-34c1-42e0-9d43-17520ba8e470/Untitled.png)
![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/38bf76e7-2f5e-470f-b7c6-585505104904/67feb613-8c8e-46f1-b5cf-b17997c3e475/Untitled.png)
![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/38bf76e7-2f5e-470f-b7c6-585505104904/96026cb4-4dbe-441a-a25b-cf0a0451e358/Untitled.png)

Далее с помощью Terraform были реализованы след операции:

1. Было создано 2 каталога, в которых будем размещать бакеты
    1. privates3-folder
    2. publics3-folder
    
![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/38bf76e7-2f5e-470f-b7c6-585505104904/12b676c8-54ee-4915-a82b-e52786a4b334/Untitled.png)
    
2. Было создано 2 сервисных аккаунта:
    1. sa-privates3
    2. sa-publics3
    
![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/38bf76e7-2f5e-470f-b7c6-585505104904/4a497c5a-3e11-415d-9bb5-eceed3121cff/Untitled.png)
    
3. Было создано 2 группы:
    1. s3-private-group
    2. s3-public-group
    
![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/38bf76e7-2f5e-470f-b7c6-585505104904/7a5dbdcb-91e5-4b16-a463-3f92ebf373b2/Untitled.png)
    
4. В каждом каталоге был создан отдельный бакет
    1. bucket-private-7jna3vwm
    2. bucket-public-7jna3vwm
    
![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/38bf76e7-2f5e-470f-b7c6-585505104904/318e50a5-011e-4bfc-9301-f3bf566f1a93/Untitled.png)
    
5. Для каждого бакета были настроены права доступа в соответствии со след правилами:
    1. на бакет **bucket-public-7jna3vwm** выданы права **storage.uploader** для групп:
        1. s3-private-group
        2. s3-public-group
    2. на бакет **bucket-private-7jna3vwm** выданы права **storage.uploader** группы s3-private-group
    3. на бакет **bucket-private-7jna3vwm** выданы права **storage.viewer** группы s3-public-group
    
![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/38bf76e7-2f5e-470f-b7c6-585505104904/38f57312-0f94-496f-8524-c3db6163fb7d/Untitled.png)
