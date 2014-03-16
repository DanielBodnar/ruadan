Event = require('./event.coffee')

class Scroll extends Event
  action: "scroll"

  constructor: (x, y, timestamp) ->
    super({
      x: x,
      y: y
    }, timestamp)

module.exports = Scroll
