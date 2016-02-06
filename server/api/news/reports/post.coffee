Controller = module.exports = (Settings, Story, Report) ->
  (request, response, next) ->
    report = request.body or {}

    Story.findOne _id: report.story
    .then (story) ->
      if not story? then next()

      story.report_count ?= 0
      story.report_count += 1

      if story.report_count > 2 and not story.is_moderated
        story.is_banned = true

      story.save() # Do some special algo stuff here

      Report.create report
    .then ((report) -> response.json report), (e) -> next e


Controller["@middlewares"] = ["CheckCaptcha"]
Controller["@require"] = [
  "igloo/settings"
  "models/news/story"
  "models/news/report"
]
Controller["@routes"] = ["/news/reports"]
Controller["@singleton"] = true