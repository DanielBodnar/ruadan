EventHandler = require('../event_handler.coffee')
AddNodesEvent = require('../../../events/mutation/add_nodes.coffee')
Deserializer = require('../../../node/deserializers/deserializer.coffee')

class AddNodes extends EventHandler
  action: AddNodesEvent::action

  constructor: (@document, @nodeMap) ->

  handle: (event) ->
    parent = @nodeMap.getNode(event.data.parentId)
    event.data.addedNodes.forEach((node) =>
      deserializedNode = @nodeMap.getNode(node.getId()) #we try to get it from the nodeMap, if it is already there
      unless deserializedNode #it's a new node, so create it.
        deserializedNode = Deserializer.deserializeSubTree(@document, node, @nodeMap)

      @document.adoptNode(deserializedNode)

      if event.data.nextSiblingId
        sibling = @nodeMap.getNode(event.data.nextSiblingId)
        parent.insertBefore(deserializedNode, sibling)
      else if event.data.previousSiblingId
        sibling = @nodeMap.getNode(event.data.previousSiblingId)
        if sibling.nextSibling
          parent.insertBefore(deserializedNode, sibling.nextSibling)
        else
          parent.appendChild(deserializedNode)
      else
        parent.appendChild(deserializedNode)
    )

module.exports = AddNodes
