module.exports =
  cache: true
  staticUrl: "https://cdn.thebigindian.news"
  url: "https://thebigindian.news"
  password:
    minStrength: 1
    limitAttempts: true
  showStack: false
  updateNotifier: enabled: false
  server:
    env: "production"
    port: 3080
    cluster: true
  redis: prefix: "bigi:"
  output:
    handleExceptions: false
    colorize: false
  logger:
    console: true
    file: false
    mongo: false
    requests: true