gulp = require('gulp')
less = require('gulp-less')
concat = require('gulp-concat')

PATHS = require('../paths.coffee')

gulp.task('css', ->
  gulp.src("#{PATHS.css}/*.less")
    .pipe(less())
    .pipe(concat('style.css'))
    .pipe(gulp.dest('./public/css'))
)
