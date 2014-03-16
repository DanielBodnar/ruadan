Event = require('./event.coffee')

class Selection extends Event
  action: "selection"

  constructor: (anchorNodeId, anchorOffset, focusNodeId, focusOffset, timestamp) ->
    super({
      anchorNodeId: anchorNodeId,
      anchorOffset: anchorOffset,
      focusNodeId: focusNodeId,
      focusOffset: focusOffset
    }, timestamp)

module.exports = Selection
