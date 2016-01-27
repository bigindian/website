path      = require "path"

# Setup the different directory variables
parentDir    = path.join __dirname, "../.."

appDir       = path.join parentDir, "server"
assetsDir    = path.join parentDir, "public_html"
publicDir    = path.join parentDir, "public_html"
backupDir    = path.join parentDir, "var/backups"

viewsDir     = path.join appDir,    "views"
modelsDir    = path.join parentDir, "etc/db"
tmpDir       = path.join parentDir, "tmp"


# Other constants
pkg          = require path.join parentDir, "package"
maxAge       = 24 * 60 * 60 * 1000


module.exports =
  sitename: "The Big Indian News"

  reCaptcha:
    enabled: false
    secret: "XXXXXXXXXX"
    siteKey: "XXXXXXXXXX"

  analyticsCode: "UA-XXXXXXXXXX-X"

  mobile: csrfBypassKey: "XXXXXXXXX"

  appDir: appDir
  assetsDir: assetsDir
  cache: false
  pkg: pkg
  publicDir: publicDir
  modelsDir: modelsDir
  backupDir: backupDir
  tmpDir: tmpDir
  showStack: true


  views:
    dir: viewsDir
    engine: "jade"

  password:
    limitAttempts: false
    minStrength: 0

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

  jade: amd:
    path: "/js/tmpl/"
    options: {}