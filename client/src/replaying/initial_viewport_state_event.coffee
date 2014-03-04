class InitialViewportStateEvent
  @handle = (event, iframe) ->
    iframe.setAttribute("frameborder", "0")

    iframe.style.width = "#{event.data.width}px"
    iframe.style.height = "#{event.data.height}px"


module.exports = InitialViewportStateEvent
