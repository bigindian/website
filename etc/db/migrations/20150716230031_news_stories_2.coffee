exports.up = (knex, Promise) ->
  knex.schema.table "news_stories", (table) ->
    table.string("excerpt", 500).nullable()
    table.string("image_url", 250).nullable()
    table.json("image_meta").defaultTo "{}"
    table.json("categories").defaultTo "[]"
    table.dropColumn "merged_story"


exports.down = (knex, Promise) ->
  knex.schema.table "news_stories", (table) ->
    table.dropColumn "excerpt"
    table.dropColumn "image_url"
    table.dropColumn "image_meta"
    table.dropColumn "categories"
    table.integer("merged_story").references("id").inTable "news_stories"