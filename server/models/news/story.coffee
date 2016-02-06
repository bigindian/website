Promise          = require "bluebird"
Schema           = (require "mongoose").Schema
url              = require "url"
validator        = require "validator"
# mongoosastic     = require "mongoosastic"
mongoosePaginate = require "mongoose-paginate"


Model = module.exports = (Elasticsearch, Mongoose, User) ->
  # **MAX_EDIT_MINS** After this many minutes, a story cannot be edited.
  MAX_EDIT_MINS = 90

  # **RECENT_DAYS** Days a story is considered recent, for resubmitting
  RECENT_DAYS = 30

  # **COOMENTS_WEIGHT**, **CLICKS_WEIGHT**, **ACTIVITY_WEIGHT** are weights
  # given while calculating a story's score.
  #
  # As the site grows, make ACTIVITY_WEIGHT go lower (0.5).
  COMMENTS_WEIGHT = 0.5
  CLICKS_WEIGHT = 1
  ACTIVITY_WEIGHT = 1

  # **CREATION_WINDOW** The window variable is used narrow down how effective
  # the creation date is when the post's hotness is calculated. A smaller window
  # allows lesser activity before the post makes it to the front page. A bigger
  # window allows more room for old stories to become popular with comments and
  # upvotes.
  #
  # Right now you're giving a 12 hour window for a new story to raise it's
  # initial hotness by 1 point.
  #
  # As the site grows, you might want to shrink this down to a 6 hour interval
  # or so.
  CREATION_WINDOW = 1000 * 60 * 60 * 12


  schema = new Schema
    title: String
    excerpt: String

    hotness: type: Number, index: true
    activity_hotness: Number

    clicks_count: type: Number, default: 1
    comments_count: Number
    is_expired: Boolean
    is_moderated: Boolean
    is_banned: Boolean
    kind: String
    merged_story: type: Schema.Types.ObjectId, ref: "Story"
    slug: String
    story_cache: String
    unavailable_at: Date
    url: String
    report_count: type: Number, default: 0
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

    created_by: type: Schema.Types.ObjectId, ref: "User"
    created_at: type: Date, default: Date.now, index: true

  schema.plugin mongoosePaginate


  schema.pre "save", (next) ->
    createdDate = Number new Date(@created_at).getTime() or Date.now()

    # Calculate the score of the clicks
    clickScore = (@clicks_count or 1) * CLICKS_WEIGHT

    # Calculate the score of the comments
    commentsScore = (@comments_count or 0) * COMMENTS_WEIGHT

    # Calculate the activity's score
    activityScore = (clickScore + commentsScore) * ACTIVITY_WEIGHT * 1.0

    # Now using the log function (which is really nice because it evens out
    # activity after a bunch of comments and clicks), calculate the number of
    # points we'll need to raise the hotness by
    activityPoints = Math.log Math.max activityScore, 1

    # The creation points is set so that newer posts get more hotness than
    # older ones. The window variable is used narrow down how effectively
    # current trending stories will take the top spot.
    creationPoints = createdDate / CREATION_WINDOW

    # The final hotness is simply the sum of all the different points.
    @hotness = activityPoints + creationPoints
    @activity_hotness = activityPoints

    do next


  Mongoose.model "Story", schema


Model["@singleton"] = true
Model["@require"] = [
  "libraries/elasticsearch"
  "libraries/mongoose"
  "models/user"
]