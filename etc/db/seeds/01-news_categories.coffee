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
      title: "Apps"
      description: "Android, iOS, Windows .."
      color: "#fffcd7"
    }
    {
      title: "World"
      description: "Travel, Cutures, News .."
      color: "#fffcd7"
    }
    {
      title: "Startups"
      description: "Startups"
      color: "#fffcd7"
    }
    {
      title: "eCommerce"
      description: "Electronic commerce"
      color: "#fffcd7"
    }
    {
      title: "Entertainment"
      description: "Entertainment"
      color: "#fffcd7"
    }
    {
      title: "Cloud"
      description: "Cloud technologies"
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
      title: "Tech & Gadgets"
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
      title: "Giants"
      description: "Apple, Facebook, Google, you know.."
      color: "#fffcd7"
    }
    {
      title: "Funding"
      description: "Funding"
      color: "#fffcd7"
    }
    {
      title: "Marketing"
      description: "Marketing"
      color: "#fffcd7"
    }
    {
      title: "Social"
      description: "Facebook, Twiiter, Instagram..."
      color: "#fffcd7"
    }
    {
      title: "Investing"
      description: "Investing & Investors"
      color: "#fffcd7"
    }
    {
      title: "Security"
      description: "Security & Safety"
      color: "#fffcd7"
    }
    {
      title: "Success Stories"
      description: "Stories of success"
      color: "#fffcd7"
    }
    {
      title: "Images"
      description: "Link to Images (gallery, photos)"
      color: "#ddebf9"
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
    {
      title: "Resource"
      description: "Resources useful for you"
      color: "#fffcd7"
    }
    {
      title: "Hardware"
      description: "Machines and things"
      color: "#fffcd7"
    }
    {
      title: "Hackathon"
      description: "Hackathons"
      color: "#fffcd7"
    }
    {
      title: "Culture"
      description: "Startup culture"
      color: "#fffcd7"
    }
    {
      title: "College"
      description: "HSC, Colleges & Unversities"
      color: "#fffcd7"
    }
    {
      title: "Advice"
      description: "Help or Advice"
      color: "#fffcd7"
    }
    {
      title: "Hiring"
      description: "Jobs & Hiring"
      color: "#fffcd7"
    }
  ]


  Promise.all (ins cat for cat in categories)