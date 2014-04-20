_ = require('lodash.custom')
BaseObserver = require('./base_observer.coffee')
ScrollEvent = require('../../events/scroll.coffee')

class ScrollObserver extends BaseObserver
  EVENTS: {
    SCROLL: 'scroll'
  }

  observe: ->
    @window.addEventListener(@EVENTS.SCROLL, @_onChange, false)

  disconnect: ->
    @window.removeEventListener(@EVENTS.SCROLL, @_onChange, false)

  _onChange: _.throttle((event) =>
    @emit(@EVENTS.SCROLL, new ScrollEvent(@window.scrollX, @window.scrollY, event.timeStamp))
  , 100)


module.exports = ScrollObserver
