coffeeify   = require "gulp-coffeeify"
foreach     = require "gulp-foreach"
uglifyJS    = require "gulp-uglifyjs"


module.exports = (gulp, config) -> ->
  gulp.src config.jsSrc

  .pipe foreach (stream, file) ->
    # For each file, minify it back into itself..
    stream.pipe uglifyJS file
    .pipe gulp.dest config.jsDest