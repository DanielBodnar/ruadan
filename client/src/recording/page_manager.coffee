Serializer = require('../node/serializers/serializer.coffee')
NewPageEvent = require('../events/new_page.coffee')
UrlEvent = require('../events/url.coffee')
ScrollEvent = require('../events/scroll.coffee')
ViewportEvent = require('../events/viewport.coffee')

class PageManager
  @newPage: (window, pageName, nodeMap, rootElement, takeSnapshot) ->
    serializedNodes = null
    if (takeSnapshot)
      serializedNodes = @_takeDOMSnapshot(nodeMap, rootElement)

    new NewPageEvent(
      pageName,
      serializedNodes,
      @_getUrlEvent(window),
      @_getScrollPositionEvent(window),
      @_getViewportSizeEvent(window)
    )

  @_getUrlEvent: (window) ->
    new UrlEvent(null, window.location.href)

  @_takeDOMSnapshot: (nodeMap, rootElement) ->
    nodeMap.clear()
    Serializer.serializeSubTree(rootElement, nodeMap)

  @_getScrollPositionEvent: (window) ->
    new ScrollEvent(window.scrollX, window.scrollY)

  @_getViewportSizeEvent: (window) ->
    new ViewportEvent(window.document.documentElement.clientWidth, window.document.documentElement.clientHeight)

module.exports = PageManager
