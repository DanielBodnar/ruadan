EventHandler = require('../event_handler.coffee')
RemoveNodesEvent = require('../../../events/mutation/remove_nodes.coffee')

class RemoveNodes extends EventHandler
  action: RemoveNodesEvent::action

  constructor: (@nodeMap) ->

  handle: (event) ->
    parent = @nodeMap.getNode(event.data.parentId)
    event.data.removedNodeIds.map(@nodeMap.getNode).forEach(parent.removeChild)

module.exports = RemoveNodes
