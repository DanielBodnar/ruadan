ShortId = require('shortid')

# responsible for generating and maintaining a unique ID per window
class WindowManager
  @getWindowId: (callback) ->
    if (@windowId?)
      @windowId
    else
      @windowId = ShortId.generate()

module.exports = WindowManager
