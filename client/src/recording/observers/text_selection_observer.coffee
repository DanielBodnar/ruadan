EventEmitter = require('eventEmitter').EventEmitter

class TextSelectionObserver extends EventEmitter
  EVENT_NAME = 'selectionchange'
  constructor: (@serializer)->
  initialize: (@element) ->
    @emit("initialize", [@_getSelection()])

  observe: ()->
    @_listener = @element.addEventListener(EVENT_NAME, @_onChange.bind(@), true)

  disconnect: ->
    @element.removeEventListener(EVENT_NAME, @_onChange.bind(@), true)

  _getSelection: (event)->
    selection = @element.getSelection()
    {
      anchorNode: @serializer.serialize(selection.anchorNode, false)
      anchorOffset: selection.anchorOffset
      focusNode: @serializer.serialize(selection.focusNode, false)
      focusOffset: selection.focusOffset
      timestamp: event?.timeStamp || (new Date().getTime())
    }

  _onChange: (event)->
    @emit('select', [@_getSelection(event)])


module.exports = TextSelectionObserver