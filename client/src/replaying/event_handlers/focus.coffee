EventHandler = require('./event_handler.coffee')
FocusEvent = require('../../events/focus.coffee')

class Focus extends EventHandler
  action: FocusEvent::action

  constructor: (@chrome) ->

  handle: (event) ->
    if (event.data.hasFocus)
      @chrome.classList.remove("nofocus")
    else
      @chrome.classList.add("nofocus")

module.exports = Focus
