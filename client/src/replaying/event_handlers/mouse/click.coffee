EventHandler = require('../event_handler.coffee')
ClickEvent = require('../../../events/mouse/click.coffee')

class Click extends EventHandler
  action: ClickEvent::action

  constructor: (@mouse) ->

  handle: (event) ->
    @mouse.addClick(event.data.x, event.data.y)

module.exports = Click
