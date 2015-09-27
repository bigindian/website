###
  @apiDefine CheckCaptcha

  @apiParam {String} gcaptcha The respsonse from Google's ReCaptcha
  @apiErrorExample {json} Captcha Error
    HTTP/1.1 403 Forbidden
    {
      "error": "reCaptchaFailed"
    }
###
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