# Controller for the logout page. If accessed, it immediately logs out the
# currently logged in user and redirects to the homepage.
Controller = module.exports = ->
  (request, response, next) ->
    request.session.destroy()
    response.redirect "/?_success=logout"


Controller["@singleton"] = true
Controller["@routes"] = ["/logout"]