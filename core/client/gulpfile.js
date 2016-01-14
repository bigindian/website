"use strict";

require("coffee-script/register");
var runSequence = require("run-sequence");

var dependencies = [
  "coffee",
  "jade",
  "sass",
  "watch",
  "md5",
  "checksum",
  "bower"
];


var gulp = require("./gulp")(dependencies);
gulp.task("post-build", ["md5", "checksum"])

gulp.task("build", runSequence(
    ["coffee", "sass", "jade"],
    "post-build"
  )
);

gulp.task("default", ["bower", "build", "watch"]);