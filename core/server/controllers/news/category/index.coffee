Controller = module.exports = (Stories) ->
  (request, response, next) ->
    #! Get the knex instance
    knex = Stories.knex

    try categoryId = request.params.slug.match(/[\w]+-(\d)/)[1]
    catch e then return next()

    #! This querybuilder fn will allow us to make a custom query
    buildQuery = (qb) ->
      #! Build the subquery. Here we select only story id that have the given
      #! category.
      subquery = knex.select "story"
        .from "news_story_category"
        .where "category", categoryId
      qb.where "id", "in", subquery

    #! Now query for the top stories using our custom querybuilder fn.
    Stories.top buildQuery, page: request.params.page or 1
    .then (results) ->

      response.render "main/news/category",
        metaRobots: "noarchive"
        cache:
          suffix: request.params.slug
          enable: true
          timeout: 60 * 10 # 10 minute cache
        data:
          collection: results.collection.toJSON()
          pagination: results.pagination
        title: null

    .catch (e) -> next e


Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = [
  "/category/:slug"
  "/category/:slug/page/:page"
]
Controller["@singleton"] = true