gulp = require('gulp')
PATHS = require('../paths.coffee')

gulp.task('watch', ->
  gulp.watch(["#{PATHS.css}/*.less"], ['css'])
)
