module.exports =
  class MutationEvent
    @handle: (event, deserializer, destDocument)->
      event.data.forEach( (data) =>
        @handleSingleMutation(deserializer, destDocument, data)
      )

    @handleSingleMutation: (deserializer, destDocument, data)->
      target = deserializer.idMap[data.targetNodeId]
      if (data.addedNodes)
        data.addedNodes.forEach((node)->
          deserializedNode = deserializer.deserialize(node, target)
          destDocument.adoptNode(deserializedNode)

          if data.nextSiblingId
            sibling = deserializer.idMap[data.nextSiblingId]
            target.insertBefore(deserializedNode, sibling)
          else if data.previousSiblingId
            sibling = deserializer.idMap[data.previousSiblingId]
            if sibling.nextSibling
              target.insertBefore(deserializedNode, sibling.nextSibling)
            else
              target.appendChild(deserializedNode)
          else
            target.appendChild(deserializedNode)
        )

      if (data.removedNodes)
        data.removedNodes.forEach((node)->
          if target
            deserializedNode = deserializer.deserialize(node, target)
            target.removeChild(deserializedNode)
            deserializer.deleteNode(node)
          else
            console.log("no target", event)
        )

      if (data.attributeName)
        target.setAttribute(data.attributeName, data.attributeValue)
