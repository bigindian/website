exports = module.exports = (Cache, Stories) ->
  routes: [
    ""
    "/page/([0-9]+)?"
  ]

  controller: (request, response, next) ->
    Cache.get "main/news/index"
    .catch ->
      Stories.top null, page: request.params[0] or 1
      .then (stories) ->

        # TODO find some other way for this..
        stories.collection = stories.collection.toJSON()
        for story in stories.collection
          delete story.created_by.password
          delete story.created_by.rss_token
          delete story.created_by.mailing_list_token

        json = JSON.stringify stories
        Cache.set "main/news/index", json, true

    .then (stories) ->
      response.render "main/news/index",
        cache: "main/news/index"
        data: JSON.parse stories
        title: null

    .catch (e) -> next e


exports["@require"] = [
  "libraries/cache"
  "models/news/stories"
]
exports["@singleton"] = true