# # News Votes Model
#
# This model simply exists as an interface for the NewsStories model. It is used
# only add votes to a model.
Model = (BaseModel) ->
  new class VotesModel extends BaseModel
    tableName: "news_votes"


Model["@require"] = ["models/base/model"]
Model["@singleton"] = true
module.exports = Model