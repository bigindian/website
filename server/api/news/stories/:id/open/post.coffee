Controller = module.exports = (Story) ->
  (request, response, next) ->
    Story.findOne _id: request.params.id
    .then (story) ->
      if request.query.botty?
        story.bot_clicks_count ?= 0
        story.bot_clicks_count += 1

      story.clicks_count ?= 0
      story.clicks_count += 1
      story.save().then -> response.json story


Controller["@require"] = ["models/news/story"]
Controller["@routes"] = ["/news/stories/:id/open"]
Controller["@singleton"] = true