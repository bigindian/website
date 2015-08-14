-- Create a user 'bignews_user' with password 'password'
CREATE ROLE bignews_user;
ALTER ROLE bignews_user with password 'password';
ALTER ROLE bignews_user WITH LOGIN;

-- Create a database 'news' and give access only to user 'bignews_user'
CREATE DATABASE bigindiannews;
REVOKE CONNECT ON DATABASE bigindiannews FROM PUBLIC;
GRANT CONNECT ON DATABASE bigindiannews TO bignews_user;
GRANT ALL ON DATABASE bigindiannews TO bignews_user;