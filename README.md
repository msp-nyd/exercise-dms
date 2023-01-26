# Migrating legacy denormalized data from CSV file into a normalized dimensional schema 

## Requirement
- Ubuntu VM or EC2 with Ubuntu Image
- Refer docker-install.md for Docker & Docker composer install


##### Below commands can be used to clean up or recreate postgres container and image
```
docker-compose stop service_postgres
docker-compose rm -f service_postgres
docker image rm postgres
docker compose up -d
docker ps
```

##### Start the postgres container in the background using -d detached mode
```
docker compose up -d
docker ps
```

#####  CREATE USER, SCHEMAS
```
docker exec -it ctr_postgres psql -U postgres -d sales_dm -f /sql/01_create_user_schema.sql
```

##### CREATE & LOAD DATE DIMENSION TABLE - DM.DIMDATE
```
docker exec -it ctr_postgres psql -U sales_dm_user -d sales_dm -f /sql/02_create_date_dimension.sql
```

##### CREATE & LOAD HISTORIC CSV DATA
```
docker exec -it ctr_postgres psql -U sales_dm_user -d sales_dm -f /sql/03_ingest_csv_legacy_data.sql
```

##### Validate the file is copied, type exit to exit bash
```
docker exec -it ctr_postgres bash

root@441ad46d1881:/# cd data
root@441ad46d1881:/data# ls
historical_orders_tumbleweed_capital.csv
```

#####  CREATE DIMENSIONAL SCHEMA FROM HISTORIC CSV DATA
```
docker exec -it ctr_postgres psql -U sales_dm_user -d sales_dm -f /sql/04_create_dimensional_schemas.sql
```

##### LOAD DIMENSIONAL SCHEMA FROM HISTORIC CSV DATA
```
docker exec -it ctr_postgres psql -U sales_dm_user -d sales_dm -f /sql/05_load_dimension_schemas.sql
```

##### To analyze sample of data in tables launch psql in the postgres container using below cmd
```
docker exec -it ctr_postgres psql -U sales_dm_user sales_dm
```

##### CREATE REPORTS
```
docker exec -it ctr_postgres psql -U sales_dm_user -d sales_dm -f /sql/06_create_load_dimensional_fact_schemas.sql
```

##### CREATE LOAD FACT SCHEMA
```
docker exec -it ctr_postgres psql -U sales_dm_user -d sales_dm -f /sql/reports/01_create_report_numberoforders_shipped_by_state.sql
docker exec -it ctr_postgres psql -U sales_dm_user -d sales_dm -f /sql/reports/02_create_report_customers_latest_address.sql
docker exec -it ctr_postgres psql -U sales_dm_user -d sales_dm -f /sql/reports/03_create_report_summary_of_orders_with_order_status.sql
docker exec -it ctr_postgres psql -U sales_dm_user -d sales_dm -f /sql/reports/04_create_report_customer_order_trends_over_years.sql
docker exec -it ctr_postgres psql -U sales_dm_user -d sales_dm -f /sql/reports/05_create_report_quarterly_sales_by_products.sql
docker exec -it ctr_postgres psql -U sales_dm_user -d sales_dm -f /sql/reports/05.1_create_report_quarterly_sales_summary_by_products.sql
docker exec -it ctr_postgres psql -U sales_dm_user -d sales_dm -f /sql/reports/06_create_report_quarterly_sales_by_customers.sql
docker exec -it ctr_postgres psql -U sales_dm_user -d sales_dm -f /sql/reports/06.1_create_report_quarterly_sales_summary_by_customers.sql
```


##### Stop the Postgres service running
```
docker-compose down
```
