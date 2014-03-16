NodeId = require('./node_id.coffee')

# NodeMap object - Meant to help remember node position, to replay dom changes
# This is due to the fact that we're getting simple domNode from the MutationObserver
# And there is no way to serialize them, and identify them later on
#
# Basically this takes a domNode as an input and returns a NodeObject
# Trying to implement this to be competible with later on switching to WeakMap
class NodeMap
  constructor: ->
    @clear()

  registerNode: (node) ->
    return null unless node
    unless (@getNode(@getNodeId(node)))
      id = @getNextId()
      NodeId.setId(node, id)
      @_nodeMap[id] = node
    @getNodeId(node)

  getNodeId: (node) ->
    return null unless node
    NodeId.getId(node)

  getNode: (id) ->
    @_nodeMap[id]

  getNextId: ->
    @currId++

  clear: ->
    @currId = 0
    @_nodeMap = {}

module.exports = NodeMap

