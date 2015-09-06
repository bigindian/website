exports.seed = (knex, Promise) ->
  post1 =
    comments_count: 1
    created_by: 1
    description: "This is sometings cool"
    description_markdown: "<p>This is sometings cool</p>"
    domain: "github.com"
    downvotes: 0
    hotness: -11088.4732896
    id: 1
    is_expired: false
    is_moderated: true
    merged_story: 1
    slug: "this-is-something-1"
    title: "This is the first link"
    upvotes: 0
    url: "https://github.com/jcs/lobsters"

  post2 =
    comments_count: 1
    created_by: 1
    description: "This is sometings cool"
    description_markdown: "<p>This is sometings cool</p>"
    domain: "github.com"
    downvotes: 0
    hotness: -11088.4732896
    id: 2
    is_expired: false
    is_moderated: true
    merged_story: 1
    slug: "this-is-something-2"
    title: "What’s Your Pain Threshold?"
    upvotes: 0
    url: "https://github.com/jcs/lobsters"


  post3 =
    comments_count: 1
    created_by: 1
    description: "This is sometings cool"
    description_markdown: "<p>This is sometings cool</p>"
    domain: "github.com"
    downvotes: 0
    hotness: -11088.4732896
    id: 3
    is_expired: false
    is_moderated: true
    merged_story: 1
    slug: "this-is-something-3"
    title: "This is the third link"
    upvotes: 0
    url: "https://github.com/jcs/lobsters"


  knex("news_stories").insert post1
  .then -> knex("news_stories").insert post2
  .then -> knex("news_stories").insert post3