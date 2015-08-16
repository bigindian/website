exports = module.exports = (Renderer, Stories) ->
  knex = Stories.knex

  controller = (request, response, next) ->
    categoryID = request.params[0]

    # This querybuilder fn will allow us to make a custom query
    buildQuery = (qb) ->
      # Build the subquery. Here we select only story id that have the given
      # category.
      subquery = knex.select "story"
        .from "news_story_category"
        .where "category", categoryID
      qb.where "id", "in", subquery

    # Now query for the top stories using our custom querybuilder fn.
    Stories.top buildQuery, page: request.params[1] or 1
    .then (stories) ->

      # TODO find some other way for this..
      stories.collection = stories.collection.toJSON()
      for story in stories.collection
        delete story.created_by.password
        delete story.created_by.rss_token
        delete story.created_by.mailing_list_token

      options =
        data: stories
        page: "news/index"
        title: null
      Renderer request, response, options
    .catch (e) -> next e


exports["@require"] = [
  "libraries/renderer"
  "models/news/stories"
]
exports["@singleton"] = true