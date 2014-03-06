EventEmitter = require('eventemitter').EventEmitter

class ViewportObserver extends EventEmitter
  initialize: (@document) ->
    @emit("initialize", [
      width: @document.clientWidth,
      height: @document.clientHeight,
      timestamp: new Date().getTime()
    ])

  observe: ->
    @document.addEventListener('mouseup', @_onClick, false)

  disconnect: ->
    @document.removeEventListener('mouseup', @_onClick, false)

  _onChange: (event) ->

module.exports = ViewportObserver
