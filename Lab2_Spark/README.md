# BigDataSpark

Анализ больших данных - лабораторная работа №2 - ETL реализованный с помощью Spark

Одним из самых популярных фреймворков для работы с Big Data является Apache Spark. Apache Spark - мощный фреймворк, который предлагает широкий набор функциональности для простого написания ETL-пайплайнов.

Что необходимо сделать? 

Необходимо реализовать ETL-пайплайн с помощью Spark, который трансформирует данные из источника (файлы mock_data.csv с номерами) в модель данных звезда в PostgreSQL, а затем на основе модели данных звезда создать ряд отчетов по данным в одной из NoSQL базах данных обязательно и в нескольких других опционально (будет бонусом). Каждый отчет представляет собой отдельную таблицу в NoSQL БД.

Какие отчеты надо создать?
1. Витрина продаж по продуктам
Цель: Анализ выручки, количества продаж и популярности продуктов.
 - Топ-10 самых продаваемых продуктов.
 - Общая выручка по категориям продуктов.
 - Средний рейтинг и количество отзывов для каждого продукта.
2. Витрина продаж по клиентам
Цель: Анализ покупательского поведения и сегментация клиентов.
 - Топ-10 клиентов с наибольшей общей суммой покупок.
 - Распределение клиентов по странам.
 - Средний чек для каждого клиента.
3. Витрина продаж по времени
Цель: Анализ сезонности и трендов продаж.
 - Месячные и годовые тренды продаж.
 - Сравнение выручки за разные периоды.
 - Средний размер заказа по месяцам.
4. Витрина продаж по магазинам
Цель: Анализ эффективности магазинов.
 - Топ-5 магазинов с наибольшей выручкой.
 - Распределение продаж по городам и странам.
 - Средний чек для каждого магазина.
5. Витрина продаж по поставщикам
Цель: Анализ эффективности поставщиков.
 - Топ-5 поставщиков с наибольшей выручкой.
 - Средняя цена товаров от каждого поставщика.
 - Распределение продаж по странам поставщиков.
6. Витрина качества продукции
Цель: Анализ отзывов и рейтингов товаров.
 - Продукты с наивысшим и наименьшим рейтингом.
 - Корреляция между рейтингом и объемом продаж.
 - Продукты с наибольшим количеством отзывов.

В каких NoSQL БД должны быть эти отчеты:
1. **Clickhouse** **(обязательно)**
2. Cassandra (опционально, если будет реализация, то это бонус)
3. Neo4J (опционально, если будет реализация, то это бонус)
4. MongoDB (опционально, если будет реализация, то это бонус)
5. Valkey (опционально, если будет реализация, то это бонус)

![Лабораторная работа №2](https://github.com/user-attachments/assets/2b854382-4c36-4542-a7fb-04fe82a6f6fa)


Алгоритм:

1. Клонируете к себе этот репозиторий.
2. Устанавливаете себе инструмент для работы с запросами SQL (рекомендую DBeaver).
3. Устанавливаете базу данных PostgreSQL (рекомендую установку через docker).
4. Устанавливаете Apache Spark (рекомендую установку через Docker. Для удобства написания кода на Python можно запустить вместе со JupyterNotebook. Для Java - подключить volume и собрать образ Docker, который будет запускать команду spark-submit с java jar-файлом при старте контейнера, сам jar файл собирается отдельно и кладется в подключенный volume)
5. Скачиваете файлы с исходными данными mock_data( * ).csv, где ( * ) номера файлов. Всего 10 файлов, каждый по 1000 строк.
6. Импортируете данные в БД PostgreSQL (например, через механизм импорта csv в DBeaver). Всего в таблице mock_data должно находиться 10000 строк из 10 файлов.
7. Анализируете исходные данные с помощью запросов.
8. Выявляете сущности фактов и измерений.
9. Реализуете приложение на Spark, которое по аналогии с первой лабораторной работой перекладывает исходные данные из PostgreSQL в модель снежинку/звезда в PostgreSQL. (Убедитесь в коннективности Spark и PostgreSQL, настройте сеть между Spark и PostgreSQL, если используете Docker).
10. Устанавливаете ClickHouse (рекомендую установку через Docker. Убедитесь в коннективности Spark и Clickhouse, настройте сеть между Spark и ClickHouse). **(обязательно)**
11. Реализуете приложение на Spark, которое создаёт все 6 перечисленных выше отчетов в виде 6 отдельных таблиц в ClickHouse. **(обязательно)**
12. Устанавливаете Cassandra (рекомендую установку через Docker. Убедитесь в коннективности Spark и Cassandra, настройте сеть между Spark и Cassandra). (опционально)
13. Реализуете приложение на Spark, которое создаёт все 6 перечисленных выше отчетов в виде 6 отдельных таблиц в Cassandra. (опционально)
14. Устанавливаете Neo4j (рекомендую установку через Docker. Убедитесь в коннективности Spark и Neo4j, настройте сеть между Spark и Neo4j). (опционально)
15. Реализуете приложение на Spark, которое создаёт все 6 перечисленных выше отчетов в виде отдельных сущностей в Neo4j. (опционально)
16. Устанавливаете MongoDB (рекомендую установку через Docker. Убедитесь в коннективности Spark и MongoDB, настройте сеть между Spark и MongoDB). (опционально)
17. Реализуете приложение на Spark, которое создаёт все 6 перечисленных выше отчетов в виде 6 отдельных коллекций в MongoDB. (опционально)
18. Устанавливаете Valkey (рекомендую установку через Docker. Убедитесь в коннективности Spark и Valkey, настройте сеть между Spark и Valkey). (опционально)
19. Реализуете приложение на Spark, которое создаёт все 6 перечисленных выше отчетов в виде отдельных записей в Valkey. (опционально)
20. Проверяете отчеты в каждой базе данных средствами языка самой БД (ClickHouse - SQL (DBeaver), Cassandra - CQL (DBeaver), Neo4J - Cipher (DBeaver), MongoDB - MQL (Compass), Valkey - redis-cli).
21. Отправляете работу на проверку лаборантам.

Что должно быть результатом работы?

1. Репозиторий, в котором есть исходные данные mock_data().csv, где () номера файлов. Всего 10 файлов, каждый по 1000 строк.
2. Файл docker-compose.yml с установкой PostgreSQL, Spark, ClickHouse **(обязательно)**, Cassandra (опционально), Neo4j (опционально), MongoDB (опционально), Valkey (опционально) и заполненными данными в PostgreSQL из файлов mock_data(*).csv.
3. Инструкция, как запускать Spark-джобы для проверки лабораторной работы.
4. Код Apache Spark трансформации данных из исходной модели в снежинку/звезду в PostgreSQL.
5. Код Apache Spark трансформации данных из снежинки/звезды в отчеты в ClickHouse.
6. Код Apache Spark трансформации данных из снежинки/звезды в отчеты в Cassandra.
7. Код Apache Spark трансформации данных из снежинки/звезды в отчеты в Neo4j.
8. Код Apache Spark трансформации данных из снежинки/звезды в отчеты в MongoDB.
9. Код Apache Spark трансформации данных из снежинки/звезды в отчеты в Valkey.


# Инструкция для запуска проекта

## 1. Запуск и проверка загрузки данных в PostgreSQL

```bash
docker-compose up -d
```

Данные загружаются автоматически при старте контейнера из 10 CSV-файлов.

```bash
docker exec -it postgres_lab2 psql -U postgres -d lab_db -c "SELECT COUNT(*) FROM mock_data;"
```
Ожидаемый результат: 10000

## 2. Построение схемы звезда
Скрипт `transform_star.py` читает mock_data из PostgreSQL и строит таблицы измерений и фактов.

```bash
docker exec -it jupyter_lab2 spark-submit \
  --master spark://spark-master:7077 \
  --jars /opt/spark/drivers/postgresql-42.7.1.jar \
  /home/jovyan/work/transform_star.py
```
Ожидаемый результат: в PostgreSQL появятся таблицы `dim_customer`, `dim_seller`, `dim_product`, `dim_store`, `dim_supplier`, `fact_sales`.

## 3. Создание отчётов в ClickHouse
Скрипт `create_reports.py` читает схему звезда и формирует 6 аналитических витрин.

```bash
docker exec -it jupyter_lab2 spark-submit \
  --master spark://spark-master:7077 \
  --jars /opt/spark/drivers/postgresql-42.7.1.jar \
  /home/jovyan/work/create_reports.py
```
## 4. Просмотр отчётов
Отчёт 1. Продажи по продуктам (топ-10)
```bash
docker exec -it clickhouse_lab2 clickhouse-client --user user --password password --query "SELECT product_name, product_category, total_qty, revenue, avg_price FROM reports.report_product_sales ORDER BY total_qty DESC LIMIT 10 FORMAT Pretty;"
```
Отчёт 2. Продажи по клиентам (топ-10)
```bash
docker exec -it clickhouse_lab2 clickhouse-client --user user --password password --query "SELECT first_name, last_name, email, country, total_spent, avg_check FROM reports.report_customer_sales ORDER BY total_spent DESC LIMIT 10 FORMAT Pretty;"
```
Отчёт 3. Продажи по времени (помесячно)
```bash
docker exec -it clickhouse_lab2 clickhouse-client --user user --password password --query "SELECT year, month, revenue, order_count, avg_order_value FROM reports.report_time_sales ORDER BY year, month FORMAT Pretty;"
```
Отчёт 4. Продажи по магазинам (топ-5)
```bash
docker exec -it clickhouse_lab2 clickhouse-client --user user --password password --query "SELECT store_name, city, country, revenue, avg_check FROM reports.report_store_sales ORDER BY revenue DESC LIMIT 5 FORMAT Pretty;"
```
Отчёт 5. Продажи по поставщикам (топ-5)
```bash
docker exec -it clickhouse_lab2 clickhouse-client --user user --password password --query "SELECT supplier_name, country, revenue, avg_price FROM reports.report_supplier_sales ORDER BY revenue DESC LIMIT 5 FORMAT Pretty;"
```
Отчёт 6. Качество продуктов (по рейтингу)
```bash
docker exec -it clickhouse_lab2 clickhouse-client --user user --password password --query "SELECT product_name, category, avg_rating, total_reviews FROM reports.report_product_quality ORDER BY avg_rating DESC FORMAT Pretty;"
```
## 5. Остановка и очистка
```bash
docker-compose down -v
```
**Используемые инструменты**

PostgreSQL — реляционная база данных для хранения исходных данных и модели «звезда».

ClickHouse — колоночная NoSQL база данных для хранения аналитических отчётов.

Apache Spark — фреймворк для распределённой обработки данных, используется для ETL и расчёта витрин.

Jupyter Notebook — среда для разработки и отладки PySpark-скриптов.

Docker — платформа для контейнеризации всех сервисов проекта.