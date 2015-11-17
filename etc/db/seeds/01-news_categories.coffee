exports.seed = (knex, Promise) ->
  uid = 0
  ins = (cat) ->
    slug = cat.toLowerCase().replace(/&/g, "").replace /[,\s]+/g, "-"
    values =
      id: ++uid
      slug: "#{slug}-#{uid}"
      title: cat
    knex("news_categories").insert values


  categories = [
    "all"
    "india"
    "business"
    "tech"
    "entertainment"
    "entrepreneurship"
    "fashion"
    "food"
    "health"
    "politics"
    "science"
    "sports"
    "world"
  ]


  Promise.all do -> ins cat for cat in categories