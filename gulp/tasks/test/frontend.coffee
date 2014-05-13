karma = require('gulp-karma')
gulp = require('gulp')

PATHS = require('../paths.coffee')

gulp.task('test:frontend', ->
  gulp.src([
    PATHS.clientTests + '/**/*.{coffee,js}',
    './test/fixtures/client/**/*.*'
  ]).pipe(karma({
    configFile: PATHS.tests + '/karma.conf.js',
    action: 'watch'
  }));
)
