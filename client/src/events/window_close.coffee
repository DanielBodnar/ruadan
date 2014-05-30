Event = require('./event.coffee')

class WindowClose extends Event
  action: "window_close"

  constructor: (timestamp) ->
    super({}, timestamp)

module.exports = WindowClose
