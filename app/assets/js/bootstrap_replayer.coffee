define([
  'jquery'
  'replaying/deserializer'
  'replaying/select_event'
  'replaying/mouse_event'
  'replaying/scroll_event'
  'replaying/mutation_event'
],(
  $
  Deserializer
  SelectEvent
  MouseEvent
  ScrollEvent
  MutationEvent
)->
  lastTime = 0;
  currentEventId = 0;
  events = null
  iframe = null
  mousePointer = null
  deserializer = null

  getNextEvent = -> events[currentEventId++]

  doEvent = (func, timestamp) ->
    setTimeout((=>
      func()
      handleEvent(getNextEvent())
    ), timestamp-lastTime)
    lastTime = timestamp

  handleEvent =  (event) ->
    return unless event
    if lastTime == 0
      lastTime = event.data.timestamp * 1

    handler = null

    switch event.action
      when "scroll"
        handler = ScrollEvent.handle.bind(ScrollEvent, event, iframe)
        break
      when "mouse"
        handler = MouseEvent.handle.bind(MouseEvent, event, mousePointer)
        break
      when "select"
        handler = SelectEvent.handle.bind(SelectEvent, event, destDocument, deserializer)
        break
      when "mutation"
        handler = MutationEvent.handle.bind(MutationEvent, event, deserializer, destDocument)
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



  $.get("http://127.0.0.1:3000/view", (data)->
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

    $(iframe).ready(->
      handleEvent(getNextEvent())
    )
  )


)
