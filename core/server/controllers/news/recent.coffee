exports = module.exports = (Stories) ->
  routes: [
    "/recent"
    "/recent/page/([0-9]+)"
  ]

  controller: (request, response, next) ->
    Stories.recent(null, page: request.params[0] or 1).then (stories) ->

      # TODO find some other way for this..
      stories.collection = stories.collection.toJSON()
      for story in stories.collection
        delete story.created_by.password
        delete story.created_by.rss_token
        delete story.created_by.mailing_list_token

      response.render "main/news/recent",
        metaRobots: "noarchive"
        cache:
          enable: true
          timeout: 60 * 1 # 1 minute cache
        data: stories
        title: null

    .catch (e) -> next e


exports["@require"] = ["models/news/stories"]
exports["@singleton"] = true