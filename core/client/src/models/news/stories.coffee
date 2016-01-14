Model = module.exports = ($log, $q, BackboneModel, BackboneCollection, Comments, Storage, Session) ->
  logger = $log.init Model.tag
  logger.log "initializing"


  # A Backbone model to represent an upvote
  UpvoteModel = BackboneModel.extend
    url: -> "/api/news/stories/#{@get 'story'}/upvote"

  # A Backbone model to represent a report
  ReportModel = BackboneModel.extend
    url: -> "/api/news/stories/#{@get 'story'}/report"


  upvotesCache = []
  upvotesCacheKey = "votes:stories:user@#{Session.user.id}"
  Storage.local(upvotesCacheKey).then (value) => upvotesCache = value


  class Stories
    @Model: BackboneModel.extend
      urlRoot: "/api/news/stories"

      defaults:
        created_at: Date.now()
        comments_count: 0
        clicks_count: 0
        created_by_uname: Session.user.get "username"
        categories: []
        meta: {}

      initialize: ->
        upvotesCacheKey = "votes:stories:user@#{Session.user.id}"
        Storage.local(upvotesCacheKey).then (value) => upvotesCache = value
        @set "voted", @id in upvotesCache


      createComment: (data) ->
        comment = new Comments.Model data
        comment.set "story", @id
        comment.save()


      upvote: ->
        # If the user has already voted for this story, then we avoid voting
        # again.
        if @id in upvotesCache then return $q.resolve {}

        # Create a up votes instance and save it in the DB
        upvote = new UpvoteModel story: @id
        upvote.save().then => @set "votes_count", 1 + @get "votes_count"
        .finally =>
          @set "voted", true
          upvotesCache.push @id
          Storage.local upvotesCacheKey, upvotesCache


      report: (data={}) ->
        data.story = @id

        # Create a report instance and save it in the DB
        report = new ReportModel data
        report.save()


      hasExcerpt: -> @get("excerpt")? and @get("excerpt").length > 1


      hasImage: -> @get("image_url")?


    @Collection: BackboneCollection.extend
      model: Stories.Model
      type: "normal" # "recent", "top"

      url: ->
        switch @type
          when "recent" then "/news/stories/recent"
          when "top" then "/news/stories/top"
          else "/news/stories"


Model.tag = "model:stories"
Model.$inject = [
  "$log"
  "$q"
  "BackboneModel"
  "BackboneCollection"
  "@models/news/comments"
  "@storage"
  "@models/session"
]