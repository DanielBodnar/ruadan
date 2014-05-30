Event = require('../event.coffee')
Deserializer = require('../../node/deserializers/deserializer.coffee')

class AddNodes extends Event
  action: "addNodesMutation"

  constructor: (addedNodes, parentId, previousSiblingId, nextSiblingId, timestamp) ->
    super({
      addedNodes: addedNodes,
      parentId: parentId,
      previousSiblingId: previousSiblingId
      nextSiblingId: nextSiblingId
    }, timestamp)

  _serializeData: ->
    {
      addedNodes: @data.addedNodes.map( (node) -> node.toJson() ),
      parentId: @data.parentId,
      previousSiblingId: @data.previousSiblingId,
      nextSiblingId: @data.nextSiblingId
    }

  @_deserializeData: (data) ->
    data.addedNodes = data.addedNodes.map( (node) -> Deserializer.nodeTreeFromJson(node) )
    data

module.exports = AddNodes
