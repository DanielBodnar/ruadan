require('coffee-script/register');
var gulp = require('gulp');
//var requireDir = require('require-dir');
var requireDirectory = require('require-directory');

//console.log(wrench.readdirSyncRecursive('my_directory_name'))
requireDirectory(module, './gulp/tasks');


gulp.task('build', ['lint', 'browserify_replayer', 'browserify_recorder', 'css'], function(){});
gulp.task('test', ['tests_mocha', 'watch']);
gulp.task('test-client', ['tests_karma']);
gulp.task('default', ['build', 'start_server', 'watch'], function () {});


