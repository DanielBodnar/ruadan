EventHandler = require('../event_handler.coffee')
ClickEvent = require('../../../events/mouse/click.coffee')

class Click extends EventHandler
  action: ClickEvent::action

  constructor: (@document) ->

  handle: (event) ->
    rippleAnimation = @document.createElement('div')
    rippleAnimation.addEventListener('webkitAnimationEnd', =>
      @document.getElementsByTagName('body')[0].removeChild(rippleAnimation)
    )
    rippleAnimation.style.left = "#{event.data.x}px"
    rippleAnimation.style.top = "#{event.data.y}px"
    rippleAnimation.id = 'circle-animation'
    @document.getElementsByTagName('body')[0].appendChild(rippleAnimation)

module.exports = Click
