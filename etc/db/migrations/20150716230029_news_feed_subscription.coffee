exports.up = (knex, Promise) ->
  knex.schema.createTable "news_feed_subscription", (table) ->
    table.increments().primary()
    table.integer("user").notNull().references("id").inTable "users"
    table.integer("feed").notNull().references("id").inTable "news_feeds"
    table.unique ["user", "feed"]


exports.down = (knex, Promise) -> knex.schema.dropTable "news_feed_subscription"