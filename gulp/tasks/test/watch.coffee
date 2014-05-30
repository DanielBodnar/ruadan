gulp = require('gulp')

gulp.task('test:watch', ->
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
    'test:all'
  ]);
)
