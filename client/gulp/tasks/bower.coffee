concat         = require "gulp-concat"
debug          = require "gulp-debug"
gulpIgnore     = require "gulp-ignore"
mainBowerFiles = require "main-bower-files"


module.exports = (gulp, config) -> ->
  gulp.src mainBowerFiles()
  .pipe debug()
  .pipe gulpIgnore.include "*.js"
  .pipe concat config.targetFilenameJs
  .pipe gulp.dest config.dest

  gulp.src mainBowerFiles()
  .pipe debug()
  .pipe gulpIgnore.include "*.css"
  .pipe concat config.targetFilenameCss
  .pipe gulp.dest config.dest