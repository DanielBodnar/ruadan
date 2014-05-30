transformTools = require('browserify-transform-tools')

module.exports =
  transformTools.makeRequireTransform('requireTransform', {evaluateArguments: true}, (files, opts, cb) ->
    minimatch = require('minimatch')
    if (minimatch(files[0], 'build_config/*.coffee', {matchbase: true}))
      env = process.env.NODE_ENV || 'development'
      newFilePath = "#{__dirname}/../../client/#{files[0].slice(0,-7)}_#{env}.coffee"
      newFile = "require('#{newFilePath}')"
      cb(null, newFile)
    else
      cb()
  )
