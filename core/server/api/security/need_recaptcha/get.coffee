Controller = module.exports = (settings) ->
  (request, response, next) ->
    #! First get the counter
    counter = request.session.recaptcha_bypass_counter or 0

    #! If the captcha is not set in the settings then ignore it.
    if not settings.reCaptcha.enabled then return response.json counter

    #! If the counter is 0 or not set, then inform the client that we need to
    #! answer the captcha for this request.
    if counter <= 0 then response.status 400

    response.json counter


Controller["@require"] = ["igloo/settings"]
Controller["@routes"] = ["/security/need_recaptcha"]
Controller["@singleton"] = true