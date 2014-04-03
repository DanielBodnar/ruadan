EventHandler = require('./event_handler.coffee')
VisibilityEvent = require('../../events/visibility.coffee')

class Visibility extends EventHandler
  action: VisibilityEvent::action

  constructor: (@chrome) ->

  handle: (event) ->
    if (event.data.visible)
      @chrome.classList.remove("hidden")
    else
      @chrome.classList.add("hidden")

module.exports = Visibility
