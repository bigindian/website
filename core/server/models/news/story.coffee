Promise   = require "bluebird"
Schema    = (require "mongoose").Schema
markdown  = require("markdown").markdown
url       = require "url"
validator = require "validator"

# helpers   = require "../helpers"


Model = module.exports = (Elasticsearch, Mongoose, User) ->
  # **MAX_EDIT_MINS** After this many minutes, a story cannot be edited.
  MAX_EDIT_MINS = 90


  # **RECENT_DAYS** Days a story is considered recent, for resubmitting
  RECENT_DAYS = 30


  COMMENTS_WEIGHT = 400
  CLICKS_WEIGHT = 1


  # **CREATION_WINDOW** The window variable is used narrow down how effective
  # the creation date is when the post's hotness is calculated. A smaller window
  # allows lesser activity before the post makes it to the front page. A bigger
  # window allows more room for old stories to become popular with comments and
  # upvotes.
  #
  # As the site grows, you might want to shrink this down to 12 or so.
  CREATION_WINDOW = 60 * 60 * 60 * 10


  schema = new Schema
    title: String
    excerpt: String

    hotness: { type: Number, index: true }
    activity_hotness: Number

    clicks_count: { type: Number, default: 1 }
    comments_count: Number
    is_expired: Boolean
    is_moderated: Boolean
    kind: String
    merged_story: { type: Schema.Types.ObjectId, ref: "Story" }
    slug: String
    story_cache: String
    unavailable_at: Date
    url: String
    words_count: Number

    image_url: String
    thumbnail:
      color: String
      filename: String
      width: Number
      height: Number

    location:
      latitude: Number
      longitude: Number

    created_by: { type: Schema.Types.ObjectId, ref: "User" }
    created_at: { type: Date, default: Date.now, index: true}


  schema.pre "save", (next) ->
    createdDate = Number new Date(@created_at).getTime() or Date.now()

    # Calculate the score of the clicks
    clickScore = (@clicks_count or 1) * CLICKS_WEIGHT

    # Calculate the score of the comments
    commentsScore = (@comments_count or 0) * COMMENTS_WEIGHT

    # Calculate the activity's score
    activityScore = Math.max (Math.abs(clickScore + 1) + commentsScore), 2

    # Now using the log function (which is really nice because it evens out
    # activity after a bunch of comments and clicks), calculate the number of
    # points we'll need to raise the hotness by
    activityPoints = Math.log Math.max(activityScore, 1), 10

    # The creation points is set so that newer posts get more hotness than
    # older ones. The window variable is used narrow down how effectively
    # current trending stories will take the top spot.
    creationPoints = createdDate / CREATION_WINDOW

    # The final hotness is simply the sum of all the different points.
    @hotness = activityPoints + creationPoints
    @activity_hotness = activityPoints

    next()


  Mongoose.model "Story", schema


Model["@singleton"] = true
Model["@require"] = [
  "libraries/elasticsearch"
  "libraries/mongoose"
  "models/user"
]