-- Create a user 'news_db' with password 'password'
CREATE ROLE news_db;
ALTER ROLE news_db with password 'password';
ALTER ROLE news_db WITH LOGIN;

-- Create a database 'news' and give access only to user 'news_db'
CREATE DATABASE news;
REVOKE CONNECT ON DATABASE news FROM PUBLIC;
GRANT CONNECT ON DATABASE news TO news_db;
GRANT ALL ON DATABASE news TO news_db;
GRANT ALL ON ALL TABLES IN DATABASE news TO news;
