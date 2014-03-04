class InitialMutationStateEvent
  @handle: (event, deserializer, destDocument) ->
    res = deserializer.deserialize(event.data.nodes)
    newNode = destDocument.adoptNode(res)
    destDocument.replaceChild(newNode, destDocument.documentElement)


module.exports = InitialMutationStateEvent
