ShortId = require('shortid')

class WindowManager
  @getWindowId: (callback) ->
    if (@windowId?)
      @windowId
    else
      @windowId = ShortId.generate()

module.exports = WindowManager
