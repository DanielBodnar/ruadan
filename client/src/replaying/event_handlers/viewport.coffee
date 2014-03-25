EventHandler = require('./event_handler.coffee')
ViewportEvent = require('../../events/viewport.coffee')

class Viewport extends EventHandler
  action: ViewportEvent::action

  constructor: (@iframe) ->

  handle: (event) ->
    @iframe.style.width = "#{event.data.width}px"
    @iframe.style.height = "#{event.data.height}px"

module.exports = Viewport
