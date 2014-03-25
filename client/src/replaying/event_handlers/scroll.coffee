EventHandler = require('./event_handler.coffee')
ScrollEvent = require('../../events/scroll.coffee')

class Scroll extends EventHandler
  action: ScrollEvent::action

  constructor: (@iframe) ->

  handle: (event) ->
    @iframe.contentWindow.scrollTo(event.data.x, event.data.y)

module.exports = Scroll
