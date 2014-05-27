EventEmitter = require('eventemitter').EventEmitter
NodeMap = require('../../../node/node_map.coffee')
Mouse = require("./mouse.coffee")

handlers = [
  
]
NewPageHandler = require('../../event_handlers/new_page.coffee')
ScrollHandler = require('../../event_handlers/scroll.coffee')
AddNodesHandler = require('../../event_handlers/mutation/add_nodes.coffee')
RemoveNodesHandler = require('../../event_handlers/mutation/remove_nodes.coffee')
CharacterDataHandler = require('../../event_handlers/mutation/character_data.coffee')
AttributeHandler = require('../../event_handlers/mutation/attribute.coffee')
SelectionHandler = require('../../event_handlers/selection.coffee')
MousePositionHandler = require('../../event_handlers/mouse/position.coffee')
MouseClickHandler = require('../../event_handlers/mouse/click.coffee')
BookmarkHandler = require('../../event_handlers/bookmark.coffee')
UrlHandler = require('../../event_handlers/url.coffee')
ViewportHandler = require('../../event_handlers/viewport.coffee')
VisibilityHandler = require('../../event_handlers/visibility.coffee')
FocusHandler = require('../../event_handlers/focus.coffee')

class Window extends EventEmitter
  constructor: (@document, container) ->
    @_initUI(container)
    @nodeMap = new NodeMap()
    @mouse = new Mouse(@document, @ui.viewport)
    @simulationDocument = @ui.iframe.contentDocument
    @_initEventHandlers()

  close: ->
    @nodeMap.clear()
    @ui.chrome.parentElement.removeChild(@ui.chrome)
    @emit("closed")

  runEvent: (event) ->
    handler = @eventHandlers.filter( (h) -> h.canHandle(event) )[0]
    if (handler)
      handler.handle(event)
    else
      console.error("No event handler found for event", event)
      throw new Exception("No event handler for event: #{event.action}")

  _initEventHandlers: ->
    @eventHandlers = [
      new MouseClickHandler(@mouse)
      new MousePositionHandler(@mouse)
      new AddNodesHandler(@simulationDocument, @nodeMap)
      new AttributeHandler(@nodeMap)
      new CharacterDataHandler(@nodeMap)
      new RemoveNodesHandler(@nodeMap)
      new BookmarkHandler()
      new SelectionHandler(@simulationDocument, @nodeMap)
      new VisibilityHandler(@ui.chrome)
      new FocusHandler(@ui.chrome)
    ]

    url = new UrlHandler(@ui.addressBar)
    scroll = new ScrollHandler(@ui.iframe)
    viewport = new ViewportHandler(@ui.chrome, @ui.iframe)
    newPage = new NewPageHandler(url, scroll, viewport, @simulationDocument, @nodeMap)

    @eventHandlers = @eventHandlers.concat(url, scroll, viewport, newPage)

  _initUI: (container) ->
    @ui = {
      chrome: @document.createElement("DIV")
      viewport: @document.createElement("DIV")
      iframe: @document.createElement("IFRAME")
      addressBar: @document.createElement("SPAN")
    }

    nofocusOverlay = @document.createElement("DIV")
    nofocusOverlay.classList.add("nofocus_overlay")

    @ui.chrome.classList.add("chrome")
    @ui.addressBar.classList.add("addressBar")
    @ui.viewport.classList.add("viewport")
    @ui.chrome.appendChild(@ui.addressBar)
    @ui.viewport.appendChild(@ui.iframe)
    @ui.chrome.appendChild(nofocusOverlay)
    @ui.chrome.appendChild(@ui.viewport)
    container.appendChild(@ui.chrome)


module.exports = Window
