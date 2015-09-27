Middleware = module.exports = (reCaptcha, ReCaptchaError) ->
  (request, response, next) ->
    reCaptcha.verify request
    .then -> next()
    .catch (e) -> next new ReCaptchaError()


Middleware["@require"] = [
  "libraries/recaptcha"
  "libraries/errors/ReCaptchaError"
]
Middleware["@singleton"] = true