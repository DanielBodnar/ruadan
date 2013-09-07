config=
  appDir: "./builtAssets/js"
  baseUrl: "./"
  dir: "public/build"
  optimize: "none"
  enforceDefine: true
#  generateSourceMaps: true
#  preserveLicenseComments: false
#  useSourceUrl: true
  paths:
    'lodash': '../../bower_components/lodash/lodash'
    'eventEmitter': '../../bower_components/eventEmitter/eventEmitter'
    'jquery': '../../bower_components/jquery/jquery'

  modules: [
    {
      name: "bootstrap_recorder"
    },
    {
      name: "bootstrap_replayer"
    }
  ]

module.exports = exports = config
