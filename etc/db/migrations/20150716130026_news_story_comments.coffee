exports.up = (knex, Promise) ->
  knex.schema.createTable "news_comments", (table) ->
    table.increments().primary()
    table.text("content").notNull().defaultTo ""
    table.text("content_markdown")
    table.string("slug").unique().index().notNull().defaultTo ""
    table.integer("votes_count").notNull().defaultTo 1
    table.decimal("hotness", 20, 10).index().notNull().defaultTo 0.0
    table.decimal("raw_hotness", 20, 10).index().notNull().defaultTo 0.0
    table.integer("parent").references("id").inTable "news_comments"
    table.boolean("is_deleted").defaultTo false
    table.boolean("is_moderated").defaultTo false
    table.boolean("is_edited").defaultTo false
    table.integer("story").notNull().references("id").inTable "news_stories"
    table.integer("created_by").notNull().references("id").inTable "users"
    table.string("created_by_uname").notNull()
    table.json("meta").defaultTo "{}"
    table.timestamp("created_at").notNull().defaultTo knex.raw "now()"
    table.timestamp("updated_at").notNull().defaultTo knex.raw "now()"


exports.down = (knex, Promise) -> knex.schema.dropTable "news_comments"