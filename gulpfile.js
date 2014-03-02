var gulp = require('gulp');
var source = require('vinyl-source-stream');
var watchify = require('watchify');
var nodemon = require('gulp-nodemon');

const build_folder = './public/build/';
gulp.task('develop', function() {
  nodemon({ script: 'server.js', ext: 'html js coffee', ignore: ['ignored.js'] })
});


gulp.task('browserify_recorder', function () {
  var bundler = watchify(['./client/src/bootstrap_recorder.coffee']);
  bundler.transform("coffeeify");
  bundler.on('update', rebundle);

  function rebundle () {
    return bundler.bundle()
        .pipe(source('recorder.js'))
        .pipe(gulp.dest(build_folder));
  }

  return rebundle();
});

gulp.task('browserify_replayer', function () {
  var bundler = watchify(['./client/src/bootstrap_replayer.coffee']);
  bundler.transform("coffeeify");
  bundler.require('./client/lodash.custom.js', {expose: 'lodash'});
  bundler.on('update', rebundle);

  function rebundle () {
    return bundler.bundle()
        .pipe(source('replayer.js'))
        .pipe(gulp.dest(build_folder));
  }

  return rebundle();
});



gulp.task('default', ['browserify_replayer', 'browserify_recorder', 'develop'], function(){
  // place code for your default task here
});
