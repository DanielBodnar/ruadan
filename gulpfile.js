require('coffee-script/register');
require('./config/application.coffee'); //needed for the helpers and some of the global app configurations
var gulp = require('gulp');

var requireDirectory = require('require-directory');

gulp.task('set_test_env', function() {
  process.env['NODE_ENV'] = 'test';
});

requireDirectory(module, './gulp/tasks');


gulp.task('build', ['lint', 'browserify_replayer', 'browserify_recorder', 'css'], function(){});
gulp.task('test:all', ['set_test_env', 'tests:frontend', 'tests:server']);
gulp.task('default', ['build', 'start_server', 'watch'], function () {});