Middleware = module.exports = (Android) ->
  (request, response, next) ->
    if request.headers["x-android"]?
      Android.findOrCreate uid: request.headers["x-android"], (error, model) ->
        request.android = model
        next()

    else next()


Middleware["@singleton"] = true
Middleware["@require"] = ["models/android"]