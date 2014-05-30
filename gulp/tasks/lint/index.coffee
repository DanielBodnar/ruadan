gulp = require('gulp')
watch = require('gulp-watch')
coffeelint = require('gulp-coffeelint')

PATHS = require('../paths.coffee')

gulp.task('lint', ->
  gulp.src("#{PATHS.client}/src/**/*.coffee")
    .pipe(watch())
    .pipe(coffeelint())
)
