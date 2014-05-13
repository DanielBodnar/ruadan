_ = require('lodash.custom')
BaseObserver = require('./base_observer.coffee')
ScrollEvent = require('../../events/scroll.coffee')

class ScrollObserver extends BaseObserver
  @EVENTS: {
    SCROLL: 'scroll'
  }

  observe: ->
    @_throttledOnChange = _.throttle(@_onChange, 100)
    @window.addEventListener(@constructor.EVENTS.SCROLL, @_throttledOnChange, false)

  disconnect: ->
    @window.removeEventListener(@constructor.EVENTS.SCROLL, @_throttledOnChange, false)

  _onChange: (event) =>
    @emit(@constructor.EVENTS.SCROLL, new ScrollEvent(@window.scrollX, @window.scrollY, event.timeStamp))


module.exports = ScrollObserver
