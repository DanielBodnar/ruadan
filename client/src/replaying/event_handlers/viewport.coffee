EventHandler = require('./event_handler.coffee')
ViewportEvent = require('../../events/viewport.coffee')

class Viewport extends EventHandler
  action: ViewportEvent::action

  constructor: (@chrome, @iframe) ->

  handle: (event) ->
    @chrome.style.left = "#{event.data.left}px"
    @chrome.style.top = "#{event.data.top}px"
    @iframe.style.width = "#{event.data.width}px"
    @iframe.style.height = "#{event.data.height}px"

module.exports = Viewport
