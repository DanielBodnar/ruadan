define([
  'lodash'
  'eventEmitter'
], (
  _
  EventEmitter
)->
  class ScrollObserver extends EventEmitter
    constructor: ->
      @_listenerFunc = (e)=> @_onChange(e)

    initialize: (@element)->
      @trigger("initialize", [x: @element.scrollX, y: @element.scrollY, timestamp: new Date().getTime()])

    observe: ()->
      @_listener = @element.addEventListener('scroll', @_listenerFunc, false)

    disconnect: ->
      @element.removeEventListener('scroll', @_listenerFunc, false)

    _onChange: (event)->
      x = @element.scrollX
      y = @element.scrollY
      console.log("scroll", x, y)
      @trigger('scroll', [{x: x, y: y, timestamp: event.timeStamp}])
)
