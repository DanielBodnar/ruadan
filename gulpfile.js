require('coffee-script/register');
var gulp = require('gulp');
//var requireDir = require('require-dir');
var requireDirectory = require('require-directory');

gulp.task('set_test_env', function() {
  process.env['NODE_ENV'] = 'test';
});

requireDirectory(module, './gulp/tasks');


gulp.task('build', ['lint', 'browserify_replayer', 'browserify_recorder', 'css'], function(){});
gulp.task('test:all', ['set_test_env', 'tests:frontend', 'tests:server', 'watch']);
gulp.task('default', ['build', 'start_server', 'watch'], function () {});