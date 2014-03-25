Event = require('./event.coffee')

class Viewport extends Event
  action: "viewport"

  constructor: (width, height, timestamp) ->
    super({
      width: width,
      height: height
    }, timestamp)

module.exports = Viewport
