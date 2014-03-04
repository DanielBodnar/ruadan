ID_PROP = '__mutation_summary_node_map_id__'

# NodeMap object - Meant to help remember node position, to replay dom changes
# This is due to the fact that we're getting simple domNode from the MutationObserver
# And there is no way to serialize them, and identify them later on
#
# Basically this takes a domNode as an input and returns a NodeObject
# Trying to implement this to be competible with later on switching to WeakMap
class NodeMap
  constructor: ->
    @currId = 0
    @_nodeMap = {}

  set: (node, value) ->
    id = ensureId(node, @getNextId())
    @_nodeMap[getId(node)] =
      k: node
      v: value
    id

  get: (node, defaultValue = null) ->
    result = defaultValue
    if hasId(node) #we might have the node
      byId = @_nodeMap[getId(node)]
      result = byId.v if byId
    #we actually found the node
    result

  has: (node) ->
    hasId(node) and getId(node) of @_nodeMap

  delete: (node) ->
    delete @_nodeMap[getId(node)] if hasId(node)

  getNextId: ->
    @currId++

#================PRIVATE========================================================
#todo: move later on to a thin wrapper for node
ensureId = (node, nextId) ->
  setId(node, nextId) unless hasId(node)
  getId(node) #we return the id

hasId = (node) ->
  getId(node)?

getId = (node) ->
  node[ID_PROP]

setId = (node, id) ->
  node[ID_PROP] = id


module.exports = NodeMap

