Event = require('../event.coffee')

class Click extends Event
  action: "mouseClick"

  constructor: (x, y, button, timestamp) ->
    super({
      x: x,
      y: y,
      button: button
    }, timestamp)

module.exports = Click
