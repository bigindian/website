knexConfig   = require "../knexfile"


module.exports =
  cache: true
  knex: knexConfig["development"]
  staticUrl: "http://localhost:3000"
  url: "http://localhost:3000"
  server:
    env: "development"
    port: 3000
  redis: prefix: "bigi-development:"
  output: level: "debug"