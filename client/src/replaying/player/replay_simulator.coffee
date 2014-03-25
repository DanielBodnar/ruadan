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
    @ui = {
      mousePointer: @document.getElementById("themouse")
      iframe: @document.getElementById("theframe")
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
