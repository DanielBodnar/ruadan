EventEmitter = require('eventemitter').EventEmitter
_ = require('lodash')
ScrollEvent = require('../../events/scroll.coffee')

class ScrollObserver extends EventEmitter
  constructor: (@window) ->
    @_throttledOnChange = _.throttle(@_onChange, 100)

  observe: ->
    @window.addEventListener('scroll', @_throttledOnChange, false)

  disconnect: ->
    @window.removeEventListener('scroll', @_throttledOnChange, false)

  _onChange: (event) =>
    @emit('scroll', new ScrollEvent(@window.scrollX, @window.scrollY, event.timeStamp))



module.exports = ScrollObserver
