var gulp = require('gulp');
var source = require('vinyl-source-stream');
var watchify = require('watchify');
var nodemon = require('gulp-nodemon');
var coffeelint = require('gulp-coffeelint');
var watch = require('gulp-watch');
var concat = require('gulp-concat');
var plumber = require('gulp-plumber');
var mocha = require('gulp-mocha');

const BUILD_FOLDER = './public/build/';

const PATHS = {
  css: './app/assets/css/**',
  tests: './test/specs',
  client: './client',
};

gulp.task('develop', function () {
  nodemon({ script: 'server.js', ext: 'html js coffee', ignore: ['ignored.js'] });
});

gulp.task('css', function(){
  var less = require('gulp-less');
  gulp.src(PATHS.css+'/*.less')
      .pipe(less())
      .pipe(concat('style.css'))
      .pipe(gulp.dest('./public/css'));
});

gulp.task('mocha', function () {
  require('coffee-script/register');
  require(PATHS.tests+'/spec_helper');

  gulp.src([PATHS.tests+'/**/*.{coffee,js}'], {read: false})
    .pipe(plumber())
    .pipe(mocha({reporter: 'spec',timeout: 200}));
});


gulp.task('lint', function () {
  gulp.src(PATHS.client+'/src/**/*.coffee')
      .pipe(watch())
      .pipe(coffeelint());
});

gulp.task('browserify_recorder', function () {
  var bundler = watchify([PATHS.client + '/src/bootstrap_recorder.coffee']);
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
  ], [
    'mocha'
  ]);

  gulp.watch([PATHS.css + '/*.less'], ['css']);
});


gulp.task('browserify_replayer', function () {
  var bundler = watchify(PATHS.client+'/src/bootstrap_replayer.coffee');
  bundler.transform('coffeeify');
  bundler.on('update', rebundle);

  function rebundle() {
    return bundler.bundle()
        .pipe(source('replayer.js'))
        .pipe(gulp.dest(BUILD_FOLDER));
  }

  return rebundle();
});

gulp.task('clear_redis', function() {
  var Redis = require('redis')
  Redis.createClient().flushdb()
});



gulp.task('default', ['lint', 'browserify_replayer', 'browserify_recorder', 'css', 'develop', 'watch'], function(){});
gulp.task('test', ['mocha', 'watch']);
