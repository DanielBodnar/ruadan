var gulp = require('gulp');

gulp.task('delete_old_sessions', function() {
  require('./delete_old_sessions')();
});

gulp.task('end_inactive_sessions', function() {
  require('./end_inactive_sessions')();
});
