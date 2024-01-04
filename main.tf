##-Создаем 2 каталога
resource "yandex_resourcemanager_folder" "publics3-folder" {
  cloud_id    = var.cloud_id
  name        = "publics3-folder"
  description = "S3 for public users"
}

resource "yandex_resourcemanager_folder" "privates3-folder" {
  cloud_id    = var.cloud_id
  name        = "privates3-folder"
  description = "S3 for private users"
}

##-Создание пользователей
resource "yandex_iam_service_account" "sa-publics3" {
  name        = "sa-publics3"
  description = "Пользователь для S3 с публичным доступом"
  folder_id   = "${yandex_resourcemanager_folder.publics3-folder.id}"
} 

resource "yandex_iam_service_account" "sa-privates3" {
  name        = "sa-privates3"
  description = "Пользователь для S3 с приватным доступом"
  folder_id   = "${yandex_resourcemanager_folder.privates3-folder.id}"
} 

##-Создание групп пользователей
resource "yandex_organizationmanager_group" "s3-public-group" {
   name            = "s3-public-group"
   description     = "Группа доступа для s3 с публичным доступом"
   organization_id = var.org_id
}

resource "yandex_organizationmanager_group" "s3-private-group" {
   name            = "s3-private-group"
   description     = "Группа доступа для s3 с приватным доступом"
   organization_id = var.org_id
}

##-Добавляем в группу s3-public-group пользователей
resource "yandex_organizationmanager_group_membership" "s3-public-group-members" {
   group_id = "${yandex_organizationmanager_group.s3-public-group.id}"
   members  = [
     "${yandex_iam_service_account.sa-publics3.id}"
   ]
}

##-Добавляем в группу s3-private-group пользователей
resource "yandex_organizationmanager_group_membership" "s3-private-group-members" {
   group_id = "${yandex_organizationmanager_group.s3-private-group.id}"
   members  = [
     "${yandex_iam_service_account.sa-privates3.id}"
   ]
}


##-Генерация random-string для имени bucket
resource "random_string" "random" {
  length           = 8
  special          = false
  upper            = false 

}

##-Генерируем статические ключи
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.service_account_id
  description        = "static access key for object storage"
}

##-Создаем публичный бакет
resource "yandex_storage_bucket" "public-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "bucket-public-${random_string.random.result}"
  
  folder_id = "${yandex_resourcemanager_folder.publics3-folder.id}"

  lifecycle_rule {
    id      = "everything1"
    prefix  = ""
    enabled = true

    expiration {
      days = 1
    }
  }
}

##-Создаем приватный бакет
resource "yandex_storage_bucket" "private-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "bucket-private-${random_string.random.result}"
  
  folder_id = "${yandex_resourcemanager_folder.privates3-folder.id}"

  lifecycle_rule {
    id      = "everything1"
    prefix  = ""
    enabled = true

    expiration {
      days = 1
    }
  }
}

##-Добавление прав на бакеты
resource "yandex_resourcemanager_folder_iam_binding" "binding-public-bucket" {
  folder_id = "${yandex_resourcemanager_folder.publics3-folder.id}"

  role = "storage.uploader"

  members = [
    "group:${yandex_organizationmanager_group.s3-private-group.id}",
    "group:${yandex_organizationmanager_group.s3-public-group.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "binding-private-bucket" {
  folder_id = "${yandex_resourcemanager_folder.privates3-folder.id}"

  role = "storage.uploader"

  members = [
    "group:${yandex_organizationmanager_group.s3-private-group.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "binding-private-bucket2" {
  folder_id = "${yandex_resourcemanager_folder.privates3-folder.id}"

  role = "storage.viewer"

  members = [
    "group:${yandex_organizationmanager_group.s3-public-group.id}"
  ]
}