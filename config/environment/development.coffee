module.exports =
  cache: true
  staticUrl: "http://0.0.0.0:3000"
  url: "http://0.0.0.0:3000"
  server:
    env: "development"
    host: "0.0.0.0"
    port: 3000
  redis: prefix: "bigi-development:"
  output: level: "debug"