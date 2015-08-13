exports.seed = (knex, Promise) ->
  comment1 =
    id: 1
    content: "I'm quite amazed at how responsive it feels compared to sharelatex or the likes. It's extremely simple. I like it. I may not use it myself, but I'll mention it to friends who are learning LaTeX."
    content_markdown: "I'm quite amazed at how responsive it feels compared to sharelatex or the likes. It's extremely simple. I like it. I may not use it myself, but I'll mention it to friends who are learning LaTeX."
    created_by: 3
    slug: "asdbc-1"
    is_moderated: true
    story: 1

  comment2 =
    id: 2
    content: "Every piece of storage news I've seen for the past year or two reinforces my opinion that there is a great deal of price-fixing happening in the consumer storage market. The price trend of 2TB HDDs, for example, just does not make sense. When I see that a company can now create SSDs with ~16x more capacity than the best consumer option, I feel like something fishy is going on that is artificially slowing the pace of larger capacity drives making it into the hands of consumers at a reasonable price."
    content_markdown: "Every piece of storage news I've seen for the past year or two reinforces my opinion that there is a great deal of price-fixing happening in the consumer storage market. The price trend of 2TB HDDs, for example, just does not make sense. When I see that a company can now create SSDs with ~16x more capacity than the best consumer option, I feel like something fishy is going on that is artificially slowing the pace of larger capacity drives making it into the hands of consumers at a reasonable price."
    created_by: 1
    slug: "asdbc-2"
    story: 1
    parent: 1
    is_moderated: true


  knex("news_comments").insert comment1
  .then -> knex("news_comments").insert comment2