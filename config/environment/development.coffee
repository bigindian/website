module.exports =
  cache: true
  staticUrl: "http://localhost:3000"
  url: "http://localhost:3000"
  server:
    env: "development"
    port: 3000
  redis: prefix: "bigi-development:"
  output: level: "debug"