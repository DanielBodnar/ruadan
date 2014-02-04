define([
  'lodash'
  'eventEmitter'
], (
  _
  EventEmitter
)->
  class TextSelectionObserver extends EventEmitter
    EVENT_NAME = 'selectionchange'
    initialize: (@element) ->
      @trigger("initialize", [@_getSelection()])

    observe: ()->
      @_listener = @element.addEventListener(EVENT_NAME, @_onChange.bind(@), true)

    disconnect: ->
      @element.removeEventListener(EVENT_NAME, @_onChange.bind(@), true)

    _getSelection: (event)->
      selection = @element.getSelection()
      {
        anchorNode: selection.anchorNode
        anchorOffset: selection.anchorOffset
        focusNode: selection.focusNode
        focusOffset: selection.focusOffset
        timestamp: event?.timeStamp || (new Date().getTime())
      }

    _onChange: _.throttle(((event)->
      @trigger('select', [@_getSelection(event)])
    ), 500)
)
