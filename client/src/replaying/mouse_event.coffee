module.exports =
  class MouseEvent
    @handle: (event, mousePointer)->
      mousePointer.style.left = "#{event.data.x}px";
      mousePointer.style.top = "#{event.data.y}px";