class NodeId
  @ID_PROP: '__mutation_summary_node_map_id__'

  @getId: (node) ->
    node[@ID_PROP]

  @setId: (node, id) ->
    node[@ID_PROP] = id

module.exports = NodeId
