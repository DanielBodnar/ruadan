gulp = require('gulp')
watchify = require('watchify')
gutil = require('gulp-util')
transformBuildConfig = require('../../helpers/build_config_transform.coffee')
rebundleHelper = require('./rebundle.coffee')

PATHS = require('../paths.coffee')

gulp.task('browserify_replayer', ->
  reBundle = -> rebundleHelper(bundler, 'replayer.js')

  bundler = watchify("#{PATHS.client}/src/bootstrap_replayer.coffee");

  bundler.transform('coffeeify')
  bundler.transform(transformBuildConfig)
  bundler.on('update', reBundle)
  bundler.on('error', gutil.log)


  reBundle()
)