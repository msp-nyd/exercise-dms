-- 01_create_user_schema.sql

-- Create new user for sales_dm 
CREATE USER sales_dm_user WITH
    LOGIN
    SUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOINHERIT
    NOREPLICATION
    PASSWORD 'salesdmpwd';

-- Create sales_dm database and assign sales_dm_user as user 
-- CREATE DATABASE sales_dm OWNER sales_dm_user;

-- Create schema legacy for historic csv data
CREATE SCHEMA legacy AUTHORIZATION sales_dm_user;

-- Create schema dm for sales datamart models
CREATE SCHEMA dm AUTHORIZATION sales_dm_user;

