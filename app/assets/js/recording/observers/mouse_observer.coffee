define([
  'lodash'
  'eventEmitter'
], (
  _
  EventEmitter
)->
  class MouseObserver extends EventEmitter
    constructor: ->
      @_listenerFunc = (e)=> @_onChange(e)

    initialize: (@element)->
      @trigger("initialize", [x: 0, y: 0, timestamp: new Date().getTime()])

    observe: ->
      @_listener = @element.addEventListener('mousemove', @_listenerFunc, false)

    disconnect: ->
      @element.removeEventListener('mousemove', @_listenerFunc, false)

    _onChange: (event)->
      x = event.pageX
      y = event.pageY
      @trigger('mouseMoved', [{x: x, y:y, timestamp: event.timeStamp}])
)
