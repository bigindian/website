Model = module.exports = ($log, $q, BackboneModel, BackboneCollection, Storage, Session) ->
  logger = $log.init Model.tag
  logger.log "initializing"


  # A Backbone model to represent an upvote
  UpvoteModel = BackboneModel.extend
    url: -> "/api/news/comments/#{@get 'comment'}/upvote"


  # Download from the cache, the list of comments that the user has already
  # voted on.
  upvotesCache = []
  upvotesCacheKey = "votes:comments:user@#{Session.user.id}"
  Storage.local(upvotesCacheKey).then (value) => upvotesCache = value


  # The main class for interacting with the comment!
  class Comments
    @Model: BackboneModel.extend
      urlRoot: "/api/news/comments"

      initialize: ->
        # Keep updating the upvotes cache
        upvotesCacheKey = "votes:comments:user@#{Session.user.id}"
        Storage.local(upvotesCacheKey).then (value) => upvotesCache = value

        # Check if the story has already been voted upon and set a flag
        # accordingly.
        @set "voted", @id in upvotesCache


      ###
        This is called whenever a model's data is returned by the server
      ###
      parse: (json) ->
        # Initialize the child comments if any..
        newChildren = []
        for child in json.children or []
          newChildren.push new Comments.Model child, parse: true
        json.children = newChildren

        # Return the newly modified JSON
        json


      ###
        Create a child comment to this one and saves it with the server.
      ###
      createChild: (content) ->
        commentModel = new Comments.Model content
        commentModel.set "parent", @id
        commentModel.set "story", @get "story"
        commentModel.save()


      ###
        Upvotes the comment.
      ###
      upvote: ->
        # If the user has already voted for this story, then we avoid voting
        # again.
        if @id in upvotesCache then return $q.resolve {}

        # Create a up votes instance and save it in the DB
        upvote = new UpvoteModel comment: @id
        upvote.save()
        .then => @set "votes_count", 1 + @get "votes_count"
        .finally =>
          @set "voted", true
          upvotesCache.push @id
          Storage.local upvotesCacheKey, upvotesCache


    @Collection: BackboneCollection.extend
      model: Comments.Model


      ###
        This is called whenever a model's data is returned by the server
      ###
      parse: (json=[]) -> @_organizeComments json


      ###
        A helper function to reorganize the comments in proper parent-child
        hierarchies.
      ###
      _organizeComments: (comments=[]) ->
        # A recursive helper function to find a parent in the given array of
        # comments.
        _findParent = (parentId, comments=[]) ->
          for comment in comments
            if comment.id is parentId then return comment
            parent = _findParent parentId, comment.children
            if parent? then return parent
          return null

        parents = []
        children = []

        # First go through all the comments and see which are parent and child
        # comments.
        for c in comments
          c.children = []
          if c.parent is null then parents.push c else children.push c

        # Now go through every single comment
        for i in [0..comments.length]
          flaws = 0

          # For every child comment, find it's parent and recurssively
          # reconstruct the parent-child tree.
          for childComment in children
            if childComment.fixed then continue

            # We try to find the parent here.
            parent = _findParent childComment.parent, parents

            # If we found a parent, then we flag the child as fixed and add it to
            # the parent.
            if parent?
              parent.children.push childComment
              childComment.fixed = true

            # Else this child is flawed, (for the moment) let's see if we'll
            # still find a parent for it once our entire loop is done.
            # TODO: check this properly... (we are not subtracting it, ever!)
            else flaws++

          # If we have reached an iteration where there were no flaws, then that
          # means all the children's parents have been found and attached
          # properly.
          if flaws is 0 then break

        # This shouldn't happen, but it means that there were a few children
        # whose parents we couldn't find.
        if flaws is not 0 then console.log "fuck"
        parents



Model.tag = "model:comments"
Model.$inject = [
  "$log"
  "$q"
  "BackboneModel"
  "BackboneCollection"
  "@storage"
  "@models/session"
]