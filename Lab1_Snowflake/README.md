# BigDataSnowflake
Анализ больших данных - лабораторная работа №1 - нормализация данных в снежинку

Одна из задач data engineer при работе с данными BigData трансформировать исходную модель данных источника в аналитическую модель данных. Аналитическая модель данных позволяет исследовать данные и принимать на основе полученных данных решения. Классическими универсальными схемами для анализа данных являются "звезда" и "снежинка". В лабораторной работе вам предстоит потренироваться в трансформации исходных данных из источников в модель данных снежинка.

Что необходимо сделать?

Необходимо данные источника (файлы mock_data.csv с номерами), которые представляют информацию о покупателях, продавцах, поставщиках, магазинах, товарах для домашних питомцев трансформировать в модель снежинка/звезда (факты и измерения с нормализацией).

<img width="1411" height="692" alt="Лабораторная работа 1" src="https://github.com/user-attachments/assets/0282c756-76a3-48f7-86e4-df6e1ec6ac89" />


## Описание
Данные из 10 CSV-файлов (информация о продажах товаров для домашних питомцев) преобразованы в нормализованную схему "снежинка": одна таблица фактов и одиннадцать таблиц измерений.

## Запуск проекта
Запустить контейнер:
```bash
docker compose up -d
```

Проверить, что всё работает:

```bash
docker exec -it snowflake_postgres psql -U postgres -d snowflake_lab -c "SELECT COUNT(*) FROM fact_sales;"
```
(Результат должен быть 10000.)

## Проверка результатов
Сводка по всем таблицам:

```bash
docker exec -it snowflake_postgres psql -U postgres -d snowflake_lab -c "SELECT * FROM view_schema_summary;"
```
Выручка по странам:

```bash
docker exec -it snowflake_postgres psql -U postgres -d snowflake_lab -c "SELECT * FROM view_revenue_by_country LIMIT 10;"
```
Топ брендов по выручке:

```bash
docker exec -it snowflake_postgres psql -U postgres -d snowflake_lab -c "SELECT * FROM view_top_brands;"
```
Остановка и очистка
```bash
docker compose down -v
```

## Схема базы данных
Таблица фактов: ``fact_sales``

Таблицы измерений: ``dim_country``, ``dim_city``, ``dim_pet_type``, ``dim_pet``, ``dim_brand``, ``dim_category``, ``dim_customer``, ``dim_seller``, ``dim_store``, ``dim_supplier``, ``dim_product``

Использованные инструменты
Docker + PostgreSQL 16, csvkit для анализа структуры CSV, DBeaver