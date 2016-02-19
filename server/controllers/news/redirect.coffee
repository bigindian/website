Controller = module.exports = (Story) ->
  (request, response, next) ->
    Story.findOne short_id: request.params.short_id
    .exec (error, story) ->
      if not story? then return do next

      story.clicks_count ?= 0
      story.clicks_count += 1

      story.share_count ?= 0
      story.share_count += 1
      story.save()

      response.redirect story.url


Controller["@require"] = ["models/news/story"]
Controller["@routes"] = ["/redirect/story/:short_id"]
Controller["@singleton"] = true