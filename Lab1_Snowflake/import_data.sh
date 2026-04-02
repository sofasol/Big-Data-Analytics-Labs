#!/bin/bash

DB_URL="postgresql://postgres:postgres@localhost:5432/snowflake_lab"
DATA_DIR="./data"

echo "Создаем таблицу и загружаем первый файл..."
csvsql --db $DB_URL \
  --insert --overwrite --tables raw_mock_data -d "," "$DATA_DIR/MOCK_DATA.csv"

for i in {1..9}; do
    echo "Загрузка файла ($i)..."
    csvsql --db $DB_URL \
      --insert --no-create --tables raw_mock_data -d "," "$DATA_DIR/MOCK_DATA ($i).csv"
done

echo "Проверка количества строк:"
psql $DB_URL -c "SELECT COUNT(*) FROM raw_mock_data;"