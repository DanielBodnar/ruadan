module.exports =
  class MouseEvent
    @handle: (event, document, mousePointer) ->
      if event.data.type == 'mousemove'
        mousePointer.style.left = "#{event.data.x}px"
        mousePointer.style.top = "#{event.data.y}px"
      else if event.data.type == 'mouseclick'
        rippleAnimation = document.createElement('div')
        rippleAnimation.addEventListener('webkitAnimationEnd', ->
          document.getElementsByTagName('body')[0].removeChild(rippleAnimation)
        )
        rippleAnimation.style.left = "#{event.data.x}px"
        rippleAnimation.style.top = "#{event.data.y}px"
        rippleAnimation.id = 'circle-animation'
        document.getElementsByTagName('body')[0].appendChild(rippleAnimation)
