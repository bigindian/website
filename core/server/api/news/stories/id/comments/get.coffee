exports = module.exports = (Story) ->
  routes: ["/news/stories/([0-9]+)/comments"]

  controller = (request, response, next) ->
    Story.comments request.params[0], request.query.page
    .then (data) ->
      comments = data.toJSON()

      # FIX
      for comment in comments
        delete comment.created_by.password
        delete comment.created_by.mailing_list_token
        delete comment.created_by.rss_token

      response.json comments
    .catch (e) ->
      response.status 404
      response.json "no comments"


exports["@require"] = ["models/news/stories"]
exports["@singleton"] = true