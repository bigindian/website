Model = module.exports = ($log, BackboneModel, BackboneCollection) ->
  logger = $log.init Model.tag
  logger.log "initializing"

  class User
    @Model: BackboneModel.extend
      urlRoot: "/api/users"
      roles:
        NORMAL: 1
        MODERATOR: 2
        ADMIN: 3

      statuses:
        INACTIVE: 0
        ACTIVE: 1
        BANNED: 2
        SUSPENDED: 3

      isActive: -> @statuses.ACTIVE is @get "status"
      isBanned: -> @statuses.BANNED is @get "status"
      isInactive: -> @statuses.INACTIVE is @get "status"
      isSuspended: -> @statuses.SUSPENDED is @get "status"

      isAdmin: -> @roles.ADMIN is @get "role"
      isModerator: -> @roles.MODERATOR is @get "role"


    @Collection = BackboneCollection.extend model: User.Model


Model.tag = "model:user"
Model.$inject = [
  "$log"
  "BackboneModel"
  "BackboneCollection"
]