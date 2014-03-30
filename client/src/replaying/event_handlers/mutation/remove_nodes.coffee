EventHandler = require('../event_handler.coffee')
RemoveNodesEvent = require('../../../events/mutation/remove_nodes.coffee')

###
  This function returns true if the expected parent of a node is the real parent of the node
  This might happen due to the fact that mutation observers return only the effected node, so when we serialize the children
  we get the incorrect state.
  so, if we have the following operations:
  insert: <a><b><c/></b></a>
  remove c: <a><b/></a>
  insert c under a: <a><b/><c/></a>

  but if we receive those as part of the same mutation events batch, the insert will represent the final
  state(since we actually traverse the dom)- so when we serialize the insert, we see: <a><b/><c/></a>
  and when we try to remove, we try to remove c from b, which will fail.
###
isRealChild= (parent, node)->
  node.parentNode == parent

class RemoveNodes extends EventHandler
  action: RemoveNodesEvent::action

  constructor: (@nodeMap) ->

  handle: (event) ->
    parent = @nodeMap.getNode(event.data.parentId)
    event.data.removedNodeIds.map(@nodeMap.getNode.bind(@nodeMap)).filter(isRealChild.bind(@, parent)).forEach(parent.removeChild.bind(parent))

module.exports = RemoveNodes
