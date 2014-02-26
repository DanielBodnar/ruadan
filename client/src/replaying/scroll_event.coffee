module.exports =
  class ScrollEvent
    @handle: (event, iframe)->
      iframe.contentWindow.scrollTo(event.data.x, event.data.y)