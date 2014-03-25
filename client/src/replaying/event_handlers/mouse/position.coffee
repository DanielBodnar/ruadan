EventHandler = require('../event_handler.coffee')
PositionEvent = require('../../../events/mouse/position.coffee')

class Position extends EventHandler
  action: PositionEvent::action

  constructor: (@mousePointer) ->

  handle: (event) ->
    @mousePointer.style.left = "#{event.data.x}px"
    @mousePointer.style.top = "#{event.data.y}px"

module.exports = Position
