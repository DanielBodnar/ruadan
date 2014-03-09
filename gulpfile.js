var gulp = require('gulp');
var source = require('vinyl-source-stream');
var watchify = require('watchify');
var nodemon = require('gulp-nodemon');
var coffeelint = require('gulp-coffeelint');
var watch = require('gulp-watch');
var concat = require('gulp-concat');
var mocha = require('gulp-mocha');

const BUILD_FOLDER = './public/build/';

gulp.task('develop', function () {
  nodemon({ script: 'server.js', ext: 'html js coffee', ignore: ['ignored.js'] })
});

gulp.task('css', function(){
  var less = require('gulp-less');
  gulp.src('./app/assets/css/**/*.less')
      .pipe(less())
      .pipe(concat('style.css'))
      .pipe(gulp.dest('./public/css'));
});

gulp.task('mocha', function () {
  require('coffee-script/register');
  require('./test/specs/spec_helper');

  gulp.src(['test/specs/**/*.{coffee,js}'], { read: false })
    .pipe(mocha({reporter: 'spec',timeout: 2000}));
});

gulp.task('test', ['mocha']);


gulp.task('lint', function () {
  gulp.src('./client/src/**/*.coffee')
      .pipe(watch())
      .pipe(coffeelint())
      .pipe(coffeelint.reporter('default'));

});

gulp.task('browserify_recorder', function () {
  var bundler = watchify(['./client/src/bootstrap_recorder.coffee']);
  bundler.transform('coffeeify');
  bundler.on('update', rebundle);

  function rebundle() {
    return bundler.bundle()
        .pipe(source('recorder.js'))
        .pipe(gulp.dest(BUILD_FOLDER));
  }

  return rebundle();
});


gulp.task('watch', function () {
  gulp.watch([
    'app/controllers/**/*.*',
    'app/helpers/**/*.*',
    'app/models/**/*.*',
    'app/routes/**/*.*',
    'app/views/**/*.*',
    'lib/**/*.*',
    'test/**/*.*',
    'client/**/*.*'
  ], function () {
    gulp.run('mocha');
  });

  gulp.watch([
    'app/assets/css/**/*.less'
  ], function(){
    gulp.run('css');
  });
});


gulp.task('browserify_replayer', function () {
  var bundler = watchify('./client/src/bootstrap_replayer.coffee');
  bundler.transform('coffeeify');
  bundler.on('update', rebundle);

  function rebundle() {
    return bundler.bundle()
        .pipe(source('replayer.js'))
        .pipe(gulp.dest(BUILD_FOLDER));
  }

  return rebundle();
});



gulp.task('default', ['lint', 'browserify_replayer', 'browserify_recorder', 'css', 'develop', 'watch'], function(){});
