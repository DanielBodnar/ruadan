gulp = require('gulp')
source = require('vinyl-source-stream')
PATHS = require('../paths.coffee')

module.exports =
  (bundler, file, dest = PATHS.buildFolder) ->
    bundler.bundle().pipe(source(file)).pipe(gulp.dest(dest))
