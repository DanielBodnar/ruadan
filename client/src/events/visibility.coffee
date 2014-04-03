Event = require('./event.coffee')

class Visibility extends Event
  action: "visibility"

  constructor: (visible, timestamp) ->
    super({
      visible: visible
    }, timestamp)

module.exports = Visibility
