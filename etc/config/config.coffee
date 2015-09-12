path      = require "path"

# Setup the different directory variables
parentDir    = path.join __dirname, "../.."

appDir       = path.join parentDir, "src/server"
assetsDir    = path.join parentDir, "content"
backupDir    = path.join parentDir, "var/backups"
modelsDir    = path.join parentDir, "etc/db"
publicDir    = path.join parentDir, "content"

viewsDir     = path.join appDir,    "views"
templatesDir = path.join viewsDir,  "emails"


# Other constants
pkg          = require path.join parentDir, "package"
maxAge       = 24 * 60 * 60 * 1000
knexConfig   = require "./knexfile"


exports = module.exports = ->
  defaults:
    sitename: "The Big Indian News"

    emailAuth:
      enabled: true
      requireActivation: true

    phonegap: csrfBypassKey: "XXXXXXXXX"

    appDir: appDir
    assetsDir: assetsDir
    backupDir: backupDir
    cache: false
    modelsDir: modelsDir
    pkg: pkg
    publicDir: publicDir

    showStack: true
    analyticsCode: "UA-XXXXXXXXXX-X"

    reCaptcha:
      enabled: false
      secret: ""
      siteKey: ""

    views:
      dir: viewsDir
      engine: "jade"

    password:
      limitAttempts: false
      minStrength: 0

    email:
      enabled: true
      noreplyAddress: "noreply@server.tld"
      webmasterAddress: "webmaster@server.tld"
      templates:
        dir: templatesDir
        options: {}
      smtp:
        hostname: "mailserver.tld"
        password: "mh76N*&="
        ssl: true
        username: "noreply@server.tld"

    session:
      cookie: maxAge: maxAge
      key: "s"
      resave: true
      saveUninitialized: false
      secret: "change-me"

    trustProxy: true

    updateNotifier:
      enabled: true
      dependencies: {}
      updateCheckInterval: 1000 * 60 * 60
      updateCheckTimeout: 1000 * 20
    staticServer: maxAge: maxAge

    server:
      host: "localhost"
      cluster: false
      ssl:
        enabled: false
        options: {}

    cookieParser: "bigi-change-me"

    csrf:
      enabled: true
      options: cookie:
        key: "XSRF-TOKEN"
        maxAge: maxAge

    redis:
      host: "localhost"
      maxAge: maxAge
      port: 6379

    output:
      colorize: true
      handleExceptions: true
      prettyPrint: false

    logger:
      console: true
      file: false
      hipchat: false
      mongo: false
      requests: true
      slack: false

    knex: client: "postgres"

    jade: amd:
      path: "/js/tmpl/"
      options: {}

  # Testing-specific options
  test:
    knex: knexConfig["staging"]
    staticUrl: "http://localhost:4000"
    url: "http://localhost:4000"
    server:
      env: "test"
      port: 4000
    redis: prefix: "bigi-testing:"
    logger:
      console: true
      requests: false
    output: level: "debug"

  # Development-specific options
  development:
    cache: true
    knex: knexConfig["development"]
    staticUrl: "http://localhost:3000"
    url: "http://localhost:3000"
    server:
      env: "development"
      port: 3000
    redis: prefix: "bigi-development:"
    output: level: "debug"

  # Production specific options
  production:
    cache: true
    knex: knexConfig["production"]
    staticUrl: "http://localhost:5000"
    url: "http://localhost:5000"
    password:
      minStrength: 1
      limitAttempts: true
    showStack: false
    updateNotifier: enabled: false
    server:
      env: "production"
      port: 5000
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


exports["@singleton"] = true