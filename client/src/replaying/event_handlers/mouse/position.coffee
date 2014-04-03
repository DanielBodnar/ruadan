EventHandler = require('../event_handler.coffee')
PositionEvent = require('../../../events/mouse/position.coffee')

class Position extends EventHandler
  action: PositionEvent::action

  constructor: (@mouse) ->

  handle: (event) ->
    @mouse.setPosition(event.data.x, event.data.y)

module.exports = Position
