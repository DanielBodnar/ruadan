Event = require('../event.coffee')

class RemoveNodes extends Event
  action: "removeNodesMutation"

  constructor: (parentId, removedNodeIds, timestamp) ->
    super({
      parentId: parentId,
      removedNodeIds: removedNodeIds
    }, timestamp)

module.exports = RemoveNodes
