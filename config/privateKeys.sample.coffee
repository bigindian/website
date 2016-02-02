module.exports =
  analyticsCode: "UA-XXXXXXXXXXXX"

  reCaptcha:
    enabled: true
    siteKey: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    serverKey: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-p02ptTRfieBBG"
    bypassKey: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

  apiKey: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

  session:
    secret: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

  mobile:
    csrfBypassKey: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

  email:
    noreplyAddress: "noreply@domain.tld"
    templates:
      options: "webmasterAddress": "webmaster@domain.tld"
    smtp:
      username: "noreply@domain.tld"
      password: "XXXXXXXXXXXX"
      hostname: "smtp.domain.tld"
      ssl: true

  oAuth:
    facebook:
      enabled: true
      clientID: "XXXXXXXXXXXXX"
      clientSecret: "XXXXXXXXXXXXX"
    google:
      enabled: true
      clientID: "XXXXXXXXXXXXX"
      clientSecret: "XXXXXXXXXXXXX"

  mongo:
    database: "thebigindian"
    host: "localhost"
    password: "XXXXXXXXXXXXXXXXXX"
    port: 27017
    username: "XXXXXXXXXXXXXXXXXX"