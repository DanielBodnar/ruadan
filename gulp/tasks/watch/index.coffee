gulp = require('gulp')
PATHS = require('../paths.coffee')

gulp.task('watch', ->
  gulp.watch([
      'app/controllers/**/*.*',
      'app/helpers/**/*.*',
      'app/models/**/*.*',
      'app/routes/**/*.*',
      'app/views/**/*.*',
      'lib/**/*.*',
      'test/**/*.*',
      'client/**/*.*'
  ], [
      'tests_mocha'
  ]);

  gulp.watch(["#{PATHS.css}/*.less"], ['css'])
)
