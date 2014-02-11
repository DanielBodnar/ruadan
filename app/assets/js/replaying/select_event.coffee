define([
],(
)->
  class SelectEvent
    @handle: (event, destDocument, deserializer)->
      startNode = deserializer.idMap[event.data.anchorNode?.id]
      endNode = deserializer.idMap[event.data.focusNode?.id]

      return unless startNode && endNode

      range = destDocument.createRange()

      range.setStart(startNode, event.data.anchorOffset)
      range.setEnd(endNode, event.data.focusOffset)
      destDocument.getSelection().removeAllRanges()
      destDocument.getSelection().addRange(range)
)