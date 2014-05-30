gulp = require('gulp')
nodemon = require('gulp-nodemon')

gulp.task('start_server', ->
  nodemon({ script: 'server.js', ext: 'html js coffee', ignore: ['ignored.js'] })
)
