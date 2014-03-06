EventEmitter = require('eventemitter').EventEmitter
_ = require('lodash')

toJson = (width, height, timestamp) ->
  width: width
  height: height
  timestamp: timestamp

getWidth= (win) ->
  win.document.documentElement.clientWidth

getHeight= (win) ->
  win.document.documentElement.clientHeight

class ViewportObserver extends EventEmitter
  initialize: (@window) ->
    @emit("initialize", [
      toJson(getWidth(@window), getHeight(@window), Date.now())
    ])

    @_debouncedOnChange = _.debounce(@_onChange, 500)

  observe: ->
    @window.addEventListener('resize', @_debouncedOnChange, true)

  disconnect: ->
    @window.removeEventListener('resize', @_debouncedOnChange, true)

  _onChange: (event) =>
    @emit('resize', [toJson(getWidth(@window), getHeight(@window), event.timeStamp)])



module.exports = ViewportObserver
