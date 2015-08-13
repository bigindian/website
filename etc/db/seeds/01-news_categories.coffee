exports.seed = (knex, Promise) ->
  uid = 0
  ins = (options) ->
    slug = options.title.toLowerCase().replace(/&/g, "").replace /[,\s]+/g, "-"
    values =
      id: ++uid
      title: options.title
      description: options.description
      inactive: options.inactive or false
      hotness_mod: options.hotness_mod or 0
      slug: "#{slug}-#{uid}"
      meta: JSON.stringify color: options.color
    knex("news_categories").insert values


  categories = [
    {
      title: "Mobile"
      description: "Android/iOS/Windows/Amazon Fire"
      color: "#fffcd7"
    }
    {
      title: "Bitcoin"
      description: "Bitcoin & Blockchain"
      color: "#fffcd7"
    }
    {
      title: "National"
      description: "India in general"
      color: "#fffcd7"
    }
    {
      title: "Education"
      description: "School, Unversities and Boards"
      color: "#fffcd7"
    }
    {
      title: "Business"
      description: "Companies, Starups"
      color: "#fffcd7"
    }
    {
      title: "Politics"
      description: "Government and organizations"
      color: "#fffcd7"
    }
    {
      title: "Economy"
      description: "Money and Finance"
      color: "#fffcd7"
    }
    {
      title: "Opinion"
      description: "Public opinion"
      color: "#fffcd7"
    }
    {
      title: "Tech"
      description: "Internet and technology"
      color: "#fffcd7"
    }
    {
      title: "Science"
      description: "Science related news"
      color: "#fffcd7"
    }
    {
      title: "Health"
      description: "Lifestyle & Health tips"
      color: "#fffcd7"
    }
    {
      title: "Sports"
      description: "All about sports"
      color: "#fffcd7"
    }
    {
      title: "Arts"
      description: "Artists, Collections & Galleries"
      color: "#fffcd7"
    }
    {
      title: "Food"
      description: "Cusines & Restaurants"
      color: "#fffcd7"
    }
    {
      title: "Travel"
      description: "Tourism, Vactioning"
      color: "#fffcd7"
    }
    {
      title: "Video"
      description: "Link to a video"
      color: "#F9DDDE"
    }
    {
      title: "Music"
      description: "Rap, Classical, Rock and more"
      color: "#F9DDDE"
    }
    {
      title: "Books"
      description: "Novels, Magazines and Authors"
      color: "#fffcd7"
    }
    {
      title: "Televison"
      description: "Serials, Shows and everything TV"
      color: "#F9DDDE"
    }
    {
      title: "Show"
      description: "Show everyone something"
      color: "#ddebf9"
    }
    {
      title: "Ask"
      description: "Ask anyone anything"
      color: "#ddebf9"
    }
  ]


  Promise.all (ins cat for cat in categories)