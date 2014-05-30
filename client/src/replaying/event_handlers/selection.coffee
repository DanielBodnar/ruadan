EventHandler = require('./event_handler.coffee')
SelectionEvent = require('../../events/selection.coffee')

class Selection extends EventHandler
  action: SelectionEvent::action

  constructor: (@document, @nodeMap) ->

  handle: (event) ->
    @document.getSelection().removeAllRanges()
    if (event.data.anchorNodeId && event.data.focusNodeId)
      startNode = @nodeMap.getNode(event.data.anchorNodeId)
      endNode = @nodeMap.getNode(event.data.focusNodeId)

      range = @document.createRange()
      range.setStart(startNode, event.data.anchorOffset)
      range.setEnd(endNode, event.data.focusOffset)
      @document.getSelection().addRange(range)

module.exports = Selection
