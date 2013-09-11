define([
  'lodash'
  'eventEmitter'
], (
  _
  EventEmitter
)->
  class MutationObserver extends EventEmitter
    constructor: ()->

    observe: (@el, options = {})->
      @_listenerFunc = (e)=> @_onChange(e)
      @_listener = @el.addEventListener('mousemove', @_listenerFunc, false)

    disconnect: ->
      @el.removeEventListener('mousemove', @_listenerFunc, false)

    _onChange: (event)->
      x = event.pageX
      y = event.pageY
      @trigger('change', [{x: x, y:y, timestamp: event.timeStamp}])
)
