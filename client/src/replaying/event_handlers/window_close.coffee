EventHandler = require('./event_handler.coffee')
WindowCloseEvent = require('../../events/window_close.coffee')

class WindowClose extends EventHandler
  action: WindowCloseEvent::action

  constructor: (@window) ->

  handle: () ->
    @window.close()

module.exports = WindowClose
