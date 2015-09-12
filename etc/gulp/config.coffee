module.exports =
  coffee:
    dest: "content/build"
    src: "src/client/main.coffee"
    targetFilename: "app.js"
    targetFilenameMin: "app.js"


  sass:
    dest: "content/build"
    src: "src/client/style.sass"
    targetFilename: "style.css"
    targetFilenameMin: "style.css"


  md5:
    dest: "content/build/md5"
    src: "content/build/*.{js,css}"


  checksum:
    dest: "content/build"
    filename: "checksums"
    hash: "md5"
    src: "content/build/*.{js,css}"


  minify:
    jsDest: "content/build/"
    jsSrc: "content/build/*.js"


  jade:
    dest: "content/build"
    src: "src/client/**/*.jade"
    targetFilename: "templates.js"
    targetFilenameMin: "templates.js"


  watch:
    coffeePattern: "src/client/**/*.{coffee,js,json}"
    jadePattern: "src/client/**/*.jade"
    sassPattern: "src/client/**/*.{sass,scss}"
    serverPattern: "src/server/views/*.coffee"


  docs:
    backend:
      dest: "docs/server"
      src: "src/server/**/*.coffee"
    frontend:
      dest: "docs/client"
      src: "src/client/**/*.coffee"
    hostname: "http://localhost:8000"


  server:
    footer:
      dest: "src/server/views/"
      src: "src/server/views/**/*.coffee"
    db:
      dest: "src/server/db"
      filename: "populate.js"
      src: "src/server/db/*.coffee"


  bower:
    dest: "content/build/"
    targetFilename: "libraries.js"