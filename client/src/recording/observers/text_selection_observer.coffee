BaseObserver = require('./base_observer.coffee')
SelectionEvent = require('../../events/selection.coffee')

class TextSelectionObserver extends BaseObserver
  @EVENTS: {
    SELECTION_CHANGED: 'select'
  }

  observe: ->
    @document.addEventListener('selectionchange', @_onChange, true)

  disconnect: ->
    @document.removeEventListener('selectionchange', @_onChange, true)

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
    @emit(@constructor.EVENTS.SELECTION_CHANGED, @_getSelection(event))


module.exports = TextSelectionObserver
