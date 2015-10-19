crypto = require "crypto"
sample = require "../samples/privateKeys.json"

module.exports = ->
  randomHash = ->
    current_date = (new Date).valueOf().toString();
    random = Math.random().toString();
    crypto.createHash "sha1"
      .update current_date + random
      .digest "hex"


  console.log "[*] Generating random session key"
  sample.session.secret = randomHash()

  console.log "[*] Generating random reCaptcha bypass key"
  sample.reCaptcha.bypassKey = randomHash()

  console.log "[*] Generating random mobile bypass key"
  sample.mobile.csrfBypassKey = randomHash()

  sample