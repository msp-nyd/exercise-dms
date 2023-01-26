# Migrating legacy denormalized data from CSV file into a normalized dimensional schema 

## Requirement
- Ubuntu VM or EC2 with Ubuntu Image
- Refer docker-install.md for Docker & Docker composer install





##### Start the container in the background using -d detached mode
##### This will start a postgres container
```
docker compose up -d
```

##### Run below cmds to clean up postgres container and image
```
docker-compose stop service_postgres
docker-compose rm -f service_postgres
docker image rm postgres
```


##### Enter a bash session in the container
```
docker exec -it postgres bash
```

##### Enter psql session as the user 'postgres'
```
psql -U postgres
```
##### List out our databases
```
\l
```
##### Connect to our sales_dm
```
\connect sales_Dm
```

##### Stop the Postgres service running
```
docker-compose down
```
