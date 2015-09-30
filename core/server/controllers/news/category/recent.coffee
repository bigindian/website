Controller = module.exports = (Stories) ->
  (request, response, next) ->
    #! Get the knex instance
    knex = Stories.knex

    categoryID = request.params[0]

    #! This querybuilder fn will allow us to make a custom query
    buildQuery = (qb) ->
      #! Build the subquery. Here we select only story id that have the given
      #! category.
      subquery = knex.select "story"
        .from "news_story_category"
        .where "category", categoryID
      qb.where "id", "in", subquery

    #! Now query for the top stories using our custom querybuilder fn.
    Stories.recent buildQuery, page: request.params[1] or 1
    .then (stories) ->

      response.render "main/news/categories",
        metaRobots: "noarchive"
        cache: #! DO for pages!
          suffix: categoryID
          enable: true
          timeout: 60 * 10 # 10 minute cache
        data: stories
        title: null

    .catch (e) -> next e


Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = [
  "/category/[a-z\-]+-([0-9]+)/recent"
  "/category/[a-z\-]+-([0-9]+)/recent/page/([0-9]+)"
]
Controller["@singleton"] = true