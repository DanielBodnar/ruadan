EventEmitter = require('eventemitter').EventEmitter
SelectionEvent = require('../../events/selection.coffee')

class TextSelectionObserver extends EventEmitter
  EVENT_NAME = 'selectionchange'
  constructor: (@document, @nodeMap) ->

  observe: ->
    @document.addEventListener(EVENT_NAME, @_onChange, true)

  disconnect: ->
    @document.removeEventListener(EVENT_NAME, @_onChange, true)

  _getSelection: (event) ->
    selection = @document.getSelection()
    new SelectionEvent(
      @nodeMap.getNodeId(selection.anchorNode),
      selection.anchorOffset,
      @nodeMap.getNodeId(selection.focusNode),
      selection.focusOffset,
      event.timeStamp
    )

  _onChange: (event) =>
    @emit('select', @_getSelection(event))


module.exports = TextSelectionObserver
