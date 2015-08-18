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
      description: "&roid/iOS/Windows/Amazon Fire"
      color: "#fffcd7"
    }
    {
      title: "Startups"
      description: "Startups"
      color: "#fffcd7"
    }
    {
      title: "Bitcoin"
      description: "Bitcoin & Blockchain"
      color: "#fffcd7"
    }
    {
      title: "India"
      description: "India in general"
      color: "#fffcd7"
    }
    {
      title: "Education"
      description: "Unversities & Education Inst."
      color: "#fffcd7"
    }
    {
      title: "Design"
      description: "Design, UI, UX"
      color: "#fffcd7"
    }
    {
      title: "Business"
      description: "Companies & Starups"
      color: "#fffcd7"
    }
    {
      title: "Politics"
      description: "Government & organizations"
      color: "#fffcd7"
    }
    {
      title: "Finance"
      description: "Money & Finance"
      color: "#fffcd7"
    }
    {
      title: "Venture"
      description: "Ventures"
      color: "#fffcd7"
    }
    {
      title: "Opinion"
      description: "Public opinion"
      color: "#fffcd7"
    }
    {
      title: "Crowdfunding"
      description: "Crowdfunding & Crowdsourcing"
      color: "#fffcd7"
    }
    {
      title: "Tech"
      description: "Internet & technology"
      color: "#fffcd7"
    }
    {
      title: "Science"
      description: "Intereting science"
      color: "#fffcd7"
    }
    {
      title: "Book"
      description: "Books"
      color: "#fffcd7"
    }
    {
      title: "Enterpreneur"
      description: "Enterpreneur"
      color: "#fffcd7"
    }
    {
      title: "Programming"
      description: "General software development"
      color: "#fffcd7"
    }
    {
      title: "Privacy"
      description: "Privacy & Anonymity"
      color: "#fffcd7"
    }
    {
      title: "Video"
      description: "Link to a video"
      color: "#F9DDDE"
    }
    {
      title: "Law"
      description: "Legal & Law"
      color: "#fffcd7"
    }
    {
      title: "Marketing"
      description: "Social media & marketing"
      color: "#fffcd7"
    }
    {
      title: "Audio"
      description: "Link to audio (podcast, interviews)"
      color: "#ddebf9"
    }
    {
      title: "Show"
      description: "Show something you made"
      color: "#ddebf9"
    }
  ]


  Promise.all (ins cat for cat in categories)