EventEmitter = require('eventemitter').EventEmitter
NodeMap = require('../../node/node_map.coffee')

NewPageHandler = require('../event_handlers/new_page.coffee')
ScrollHandler = require('../event_handlers/scroll.coffee')
AddNodesHandler = require('../event_handlers/mutation/add_nodes.coffee')
RemoveNodesHandler = require('../event_handlers/mutation/remove_nodes.coffee')
CharacterDataHandler = require('../event_handlers/mutation/character_data.coffee')
AttributeHandler = require('../event_handlers/mutation/attribute.coffee')
SelectionHandler = require('../event_handlers/selection.coffee')
MousePositionHandler = require('../event_handlers/mouse/position.coffee')
MouseClickHandler = require('../event_handlers/mouse/click.coffee')
BookmarkHandler = require('../event_handlers/bookmark.coffee')
UrlHandler = require('../event_handlers/url.coffee')
ViewportHandler = require('../event_handlers/viewport.coffee')



MOUSE_ELEMENT_ID= "themouse"
IFRAME_ELEMENT_ID = "theframe"


createIframe = (document)->
  iframe = document.createElement('iframe')
  iframe.setAttribute('id', IFRAME_ELEMENT_ID)
  iframe.setAttribute('scrolling', 'no')
  iframe.setAttribute('sandbox', 'allow-same-origin')
  iframe


createMouse = (document)->
  mouse = document.createElement('div')
  mouse.setAttribute('id', MOUSE_ELEMENT_ID)
  mouse.innerHTML = '<img src="//mouse_icon.svg" width="12px" height="20px"/>'
  mouse

createUIElements = (document) ->
  iframe = createIframe(document)
  mouse = createMouse(document)

  document.body.appendChild(iframe)
  document.body.appendChild(mouse)

  iframe: iframe
  mouse: mouse



class ReplaySimulator extends EventEmitter

  constructor: (@events, @document) ->
    @nodeMap = new NodeMap()
    @initUI()
    @initEventHandlers();
    @resetDocument()

  resetDocument: ->
    @lastPlayedTimestamp = null
    @emit("reset")

  runToTimestamp: (targetTimestamp) ->
    if (targetTimestamp < @lastPlayedTimestamp)
      @resetDocument()
      @runToTimestamp(targetTimestamp)
    else
      eventsToRun = @getEventsInRange(@lastPlayedTimestamp, targetTimestamp)
      if (eventsToRun.length > 0)
        @runEvents(eventsToRun)
        @lastPlayedTimestamp = eventsToRun[eventsToRun.length - 1].timestamp

        if (@lastPlayedTimestamp == @events[@events.length - 1].timestamp)
          @emit("simulationEnd")

  getEventsInRange: (start, end) ->
    result = []
    for event in @events
      if ((start == null || event.timestamp > start) && (end == null || event.timestamp <= end))
        result.push(event)
    result

  runEvents: (events) ->
    events.forEach( (event) =>
      @runEvent(event)
    )

  runEvent: (event) ->
    handler = @eventHandlers.filter( (h) -> h.canHandle(event) )[0]
    if (handler)
      handler.handle(event)
    else
      console.error("No event handler found for event", event)
      throw new Exception("No event handler for event: " + event.action)

  initUI: ->
    result = createUIElements(@document)
    @ui = {
      mousePointer: result.mouse
      iframe: result.iframe
    }
    @simulationDocument = @ui.iframe.contentDocument

  initEventHandlers: ->
    @eventHandlers = [
      new MouseClickHandler(@document)
      new MousePositionHandler(@ui.mousePointer)
      new AddNodesHandler(@simulationDocument, @nodeMap)
      new AttributeHandler(@nodeMap)
      new CharacterDataHandler(@nodeMap)
      new RemoveNodesHandler(@nodeMap)
      new BookmarkHandler()
      new SelectionHandler(@simulationDocument, @nodeMap)
    ]

    url = new UrlHandler()
    scroll = new ScrollHandler(@ui.iframe)
    viewport = new ViewportHandler(@ui.iframe)
    newPage = new NewPageHandler(url, scroll, viewport, @simulationDocument, @nodeMap)

    @eventHandlers = @eventHandlers.concat(url, scroll, viewport, newPage)

module.exports = ReplaySimulator
