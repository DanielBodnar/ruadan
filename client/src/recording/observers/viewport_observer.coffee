EventEmitter = require('eventemitter').EventEmitter

class ViewportObserver extends EventEmitter
  initialize: (@element)->
    @emit("initialize", [
      width: @element.clientWidth,
      height: @element.clientHeight,
      timestamp: new Date().getTime()
    ])

  observe: ()->

  disconnect: ->

  _onChange: (event)->

module.exports = ViewportObserver
