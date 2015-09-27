Controller = module.exports = (Story) ->
  (request, response, next) ->
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


Controller["@require"] = ["models/news/stories"]
Controller["@singleton"] = true
Controller["@routes"] = ["/news/stories/([0-9]+)/comments"]