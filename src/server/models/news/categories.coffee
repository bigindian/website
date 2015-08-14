exports = module.exports = (BaseModel) ->
  class Model extends BaseModel
    tableName: "news_categories"
    full_cache: true

    getStoryCount: ->
      @knex.select("category").from "news_story_category"
      .count("* as stories").groupBy "category"


  new Model


exports["@singleton"] = true
exports["@require"] = [
  "models/base/model"
]
