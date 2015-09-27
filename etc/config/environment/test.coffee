knexConfig   = require "../knexfile"


module.exports =
  knex: knexConfig["staging"]
  staticUrl: "http://localhost:5000"
  url: "http://localhost:5000"
  server:
    env: "test"
    port: 5000
  redis: prefix: "bigi-testing:"
  logger:
    console: true
    requests: false
  output: level: "debug"