Event = require('../event.coffee')

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

module.exports = AddNodes
