Serializer = require('../node/serializer.coffee')
NewPageEvent = require('./events/new_page.coffee')
UrlEvent = require('./events/url.coffee')
ScrollEvent = require('./events/scroll.coffee')
ViewportEvent = require('./events/viewport.coffee')
SelectionEvent = require('./events/scroll.coffee')

class PageManager
  @newPage: (window, pageName, nodeMap, rootElement, takeSnapshot) ->
    serializedNodes = null
    if (takeSnapshot)
      serializedNodes = @_takeDOMSnapshot(nodeMap, rootElement)

    new NewPageEvent(
      serializedNodes,
      @_getUrlEvent(window),
      @_getScrollPositionEvent(window),
      @_getViewportSizeEvent(window),
      @_getSelectionEvent(nodeMap, window.document)
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

  @_getSelectionEvent: (nodeMap, document) ->
    selection = document.getSelection()
    new SelectionEvent(
      nodeMap.getNodeId(selection.anchorNode),
      selection.anchorOffset,
      nodeMap.getNodeId(selection.focusNode),
      selection.focusOffset
    )

module.exports = PageManager
