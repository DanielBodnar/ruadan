gulp = require('gulp')
watchify = require('watchify')
gutil = require('gulp-util')
transformBuildConfig = requireApp('./gulp/helpers/build_config_transform.coffee')
rebundleHelper = require('./rebundle.coffee')

PATHS = require('../paths.coffee')

gulp.task('browserify_recorder', ->
  reBundle = -> rebundleHelper(bundler, 'recorder.js')

  bundler = watchify("#{PATHS.client}/src/bootstrap_recorder.coffee")

  bundler.transform('coffeeify');
  bundler.transform(transformBuildConfig);
  bundler.on('update', reBundle)


  reBundle()
)


