Event = require('./event.coffee')

class Viewport extends Event
  action: "viewport"

  constructor: (x, y, width, height, timestamp) ->
    super({
      x: x,
      y: y,
      width: width,
      height: height
    }, timestamp)

module.exports = Viewport
