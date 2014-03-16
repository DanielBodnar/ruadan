Event = require('../event.coffee')

class RemoveNodes extends Event
  action: "removeNodesMutation"

  constructor: (removedNodeIds, timestamp) ->
    super({
      removedNodeIds: removedNodeIds
    }, timestamp)

module.exports = RemoveNodes
