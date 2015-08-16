# Controller for the privacy page. Simply displays the privacy policy view.
exports = module.exports = (Renderer) ->
  controller = (request, response, next) ->
    args =
      page: "info/terms-privacy"
      title: response.__ "title.terms-privacy"

    Renderer request, response, args, true


exports["@require"] = ["libraries/renderer"]
exports["@singleton"] = true