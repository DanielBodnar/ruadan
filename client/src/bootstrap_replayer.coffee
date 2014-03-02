Deserializer = require('./replaying/deserializer.coffee')
SelectEvent = require('./replaying/select_event.coffee')
MouseEvent = require('./replaying/mouse_event.coffee')
ScrollEvent = require('./replaying/scroll_event.coffee')
MutationEvent = require('./replaying/mutation_event.coffee')

lastTime = 0;
currentEventId = 0;
events = null
iframe = null
mousePointer = null
deserializer = null

getNextEvent = ->
  events[currentEventId++]

doEvent = (func, timestamp) ->
  setTimeout((=>
    func()
    handleEvent(getNextEvent())
  ), timestamp - lastTime)
  lastTime = timestamp

handleEvent = (event) ->
  return unless event
  if lastTime == 0
    lastTime = event.data.timestamp * 1

  handler = null

  switch event.action
    when "scroll"
      handler = -> ScrollEvent.handle(event, iframe)
      break
    when "mouse"
      handler = -> MouseEvent.handle(event, mousePointer)
      break
    when "select"
      handler = -> SelectEvent.handle(event, destDocument, deserializer)
      break
    when "mutation"
      handler = -> MutationEvent.handle(event, deserializer, destDocument)
      break
    else
      handler = null

  if handler
    doEvent(handler, event.data.timestamp * 1)
  else
    console.log("unhandled event", event)
    handleEvent(getNextEvent())


mousePointer = document.getElementById("themouse")

iframe = document.getElementById("theframe")


destDocument = iframe.contentDocument



doReplay = (data) ->

  deserializer = new Deserializer(document)
  res = deserializer.deserialize(data.initialMutationState.nodes)

  newNode = destDocument.adoptNode(res)

  destDocument.replaceChild(newNode, destDocument.documentElement)

  iframe.contentWindow.scrollTo(data.initialScrollState.x, data.initialScrollState.y)

  iframe.setAttribute("width", "#{data.initialViewportState.width}")
  iframe.setAttribute("height", "#{data.initialViewportState.height}")

  iframe.setAttribute("frameborder", "0")

  iframe.style.width = "#{data.initialViewportState.width}px"
  iframe.style.height = "#{data.initialViewportState.height}px"

  events = data.events
  handleEvent(getNextEvent()) #dont know how to get the event that the iframe finished loading :(

replay = ->
  request = new XMLHttpRequest;
  request.open('GET', "http://127.0.0.1:3000/view", true)

  request.onload = ->
    if (request.status >= 200 && request.status < 400)
      data = JSON.parse(request.responseText);
      doReplay(data)
    else
      console.error("error requesting info from the server", request)

  request.onerror = ->
    console.error("error requesting info from the server", request)

  request.send()

replay()
module.exports.replay = replay
