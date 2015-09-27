###
  This file should contain DB credentials for the app. You must fill this up
  accordingly. We recommend using PostgreSQL because of it's recent JSON
  support.

  The app switches from either using the 'development', 'staging' or
  'production' values based on the value set by $NODE_ENV.
###
module.exports =
  development:
    debug: true
    client: "postgres"
    connection:
      database: "thebigindian_development"
      user:     "thebigindian_user"
      password: "password"
    pool:
      min: 2
      max: 10
    migrations: tableName: "migrations"


  staging:
    client: "postgres"
    connection:
      host: "db.sitename.tld"
      database: "thebigindian_testing"
      user:     "thebigindian_user"
      password: "password"
    pool:
      min: 2
      max: 10
    migrations: tableName: "migrations"


  production:
    client: "postgres"
    connection:
      host: "db.sitename.tld"
      database: "thebigindian"
      user:     "thebigindian_user"
      password: "password"
    pool:
      min: 2
      max: 10
    migrations: tableName: "migrations"
