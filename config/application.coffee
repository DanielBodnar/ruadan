path = require('path')
GLOBAL.APP_ROOT = path.resolve(__dirname, '..')
GLOBAL.requireApp = (path) ->
  args = Array.prototype.slice.call(arguments)
  require.apply(null, [GLOBAL.APP_ROOT + "/" + path].concat(args.slice(1)))


module.exports = requireApp('./app/app.coffee').app