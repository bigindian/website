runSequence = require "run-sequence"
watch       = require "gulp-watch"


module.exports = (gulp, config) -> ->
  sequence = runSequence.use gulp

  gulp.task "watch:coffee", -> sequence "coffee", "post-build"
  gulp.task "watch:jade", -> sequence "jade", "post-build"
  gulp.task "watch:sass", -> sequence "sass", "post-build"

  gulp.watch config.coffeePattern, ["watch:coffee"]
  gulp.watch config.jadePattern, ["watch:jade"]
  gulp.watch config.sassPattern, ["watch:sass"]