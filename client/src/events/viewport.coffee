Event = require('./event.coffee')

class Viewport extends Event
  action: "viewport"

  constructor: (left, top, width, height, timestamp) ->
    super({
      left: left,
      top: top,
      width: width,
      height: height
    }, timestamp)

module.exports = Viewport
