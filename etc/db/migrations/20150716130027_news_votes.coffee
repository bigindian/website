exports.up = (knex, Promise) ->
  knex.schema.createTable "news_votes", (table) ->
    table.increments().primary()
    table.integer("user").notNull().references("id").inTable "users"
    table.integer("story").references("id").inTable "news_stories"
    table.integer("comment").references("id").inTable "news_comments"
    table.timestamp("created_at").notNull().defaultTo knex.raw "now()"
    table.timestamp("updated_at").notNull().defaultTo knex.raw "now()"
    table.unique ["story", "user"]
    table.unique ["comment", "user"]


exports.down = (knex, Promise) -> knex.schema.dropTable "news_votes"