fs = require 'fs'

# Recursively require a folder’s files
exports.autoload = autoload = (dir, app) ->
  fs.readdirSync(dir).forEach (file) ->
    path = "#{dir}/#{file}"
    stats = fs.lstatSync(path)

    # Go through the loop again if it is a directory
    if stats.isDirectory()
      autoload path, app
    else
      require(path)?(app)

# Return last item of an array
# ['a', 'b', 'c'].last() => 'c'
Array::last = ->
  this[this.length - 1]