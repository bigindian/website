module.exports =
  coffee:
    dest: "../public_html/build"
    src: "src/main.coffee"
    targetFilename: "app.js"
    targetFilenameMin: "app.js"


  sass:
    dest: "../public_html/build"
    src: "src/style.sass"
    targetFilename: "style.css"
    targetFilenameMin: "style.css"


  md5:
    dest: "../public_html/build/md5"
    src: "../public_html/build/*.{js,css}"


  checksum:
    dest: "../public_html/build"
    filename: "checksums"
    hash: "md5"
    src: "../public_html/build/*.{js,css}"


  minify:
    jsDest: "../public_html/build/"
    jsSrc: "../public_html/build/*.js"


  jade:
    dest: "../public_html/build"
    src: "src/**/*.jade"
    targetFilename: "templates.js"
    targetFilenameMin: "templates.js"


  watch:
    coffeePattern: "src/**/*.{coffee,js,json}"
    jadePattern: "src/**/*.jade"
    sassPattern: "src/**/*.{sass,scss}"
    serverPattern: "core/server/views/*.coffee"


  docs:
    frontend:
      dest: "../../docs/client"
      src: "src/**/*.coffee"
    hostname: "http://localhost:8000"


  bower:
    dest: "../public_html/build/"
    targetFilenameJs: "libraries.js"
    targetFilenameCss: "libraries.css"