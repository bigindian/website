"use strict";

require("coffee-script/register");
var runSequence = require("run-sequence");

var dependencies = [
  "checksum",
  "coffee",
  "jade",
  "md5",
  "sass",
  "watch"
];


var gulp = require("./gulp")(dependencies);
gulp.task("post-build", ["md5", "checksum"])

gulp.task("build", runSequence(
    ["coffee", "sass", "jade"],
    "post-build"
  )
);

gulp.task("default", ["build", "watch"]);