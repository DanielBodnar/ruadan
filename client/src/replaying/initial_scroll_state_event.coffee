class InitialScrollStateEvent
  @handle = (event, iframe) ->
    iframe.contentWindow.scrollTo(event.data.x, event.data.y)

module.exports = InitialScrollStateEvent
