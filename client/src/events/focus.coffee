Event = require('./event.coffee')

class Focus extends Event
  action: "focus"

  constructor: (hasFocus, timestamp) ->
    super({
      hasFocus: hasFocus
    }, timestamp)

module.exports = Focus
