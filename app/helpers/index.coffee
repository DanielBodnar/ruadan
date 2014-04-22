fs = require('fs')
path = require('path')

# Recursively require a folder’s files
exports.runForEachFile = runForEachFile = (dir, func)->
  fs.readdirSync(dir).forEach((file) ->

    file = path.join(dir, file)
    stats = fs.lstatSync(file)

    # Go through the loop again if it is a directory
    if stats.isDirectory()
      runForEachFile(file, func)
    else
      func(file)
  )

exports.autoload = autoload = (dir, app) ->
  runForEachFile(dir, (file)->
    require(file)?(app)
  )

# Return last item of an array
# ['a', 'b', 'c'].last() => 'c'
Array::last = ->
  this[this.length - 1]

# Capitalize a string
# string => String
String::capitalize = () ->
    this.replace /(?:^|\s)\S/g, (a) -> a.toUpperCase()

# Classify a string
# application_controller => ApplicationController
String::classify = (str) ->
  classified = []
  words = str.split('_')
  for word in words
    classified.push word.capitalize()

  classified.join('')
