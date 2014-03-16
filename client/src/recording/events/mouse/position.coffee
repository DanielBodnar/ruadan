Event = require('../event.coffee')

class Position extends Event
  action: "mousePosition"

  constructor: (x, y, timestamp) ->
    super({
      x: x,
      y: y
    }, timestamp)

module.exports = Position
