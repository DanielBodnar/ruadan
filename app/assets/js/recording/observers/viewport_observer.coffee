define([
  'eventEmitter'
],(
  EventEmitter
)->
  class ViewportObserver extends EventEmitter
    initialize: (@element)->
      @trigger("initialize", [
        width: @element.clientWidth,
        height: @element.clientHeight,
        timestamp: new Date().getTime()
      ])

    observe: ()->

    disconnect: ->

    _onChange: (event)->
)
