EventEmitter = require('eventemitter').EventEmitter
Deserializer = require('../deserializer.coffee')
SelectEvent = require('../select_event.coffee')
MouseEvent = require('../mouse_event.coffee')
ScrollEvent = require('../scroll_event.coffee')
MutationEvent = require('../mutation_event.coffee')
InitialMutationStateEvent = require('../initial_mutation_state_event.coffee')
InitialScrollStateEvent = require('../initial_scroll_state_event.coffee')
InitialViewportStateEvent = require('../initial_viewport_state_event.coffee')


class ReplaySimulator extends EventEmitter
  constructor: (@events, @document) ->
    @initUI()
    @resetDocument()

  resetDocument: ->
    @lastPlayedTimestamp = 0
    @emit("reset")

    @deserializer = new Deserializer(@simulationDocument)

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
      if (event.timestamp > start && event.timestamp <= end)
        result.push(event)
    result

  runEvents: (events) ->
    events.forEach( (event) =>
      @runEvent(event)
    )

  runEvent: (event) ->
    switch (event.action)
      when "scroll"
        ScrollEvent.handle(event, @ui.iframe)
        break
      when "mouse"
        MouseEvent.handle(event, @document, @ui.mousePointer)
        break
      when "select"
        SelectEvent.handle(event, @simulationDocument, @deserializer)
        break
      when "mutation"
        MutationEvent.handle(event, @deserializer, @simulationDocument)
        break
      when "initialMutationState"
        InitialMutationStateEvent.handle(event, @deserializer, @simulationDocument)
        break
      when "initialScrollState"
        InitialScrollStateEvent.handle(event, @ui.iframe)
        break
      when "initialViewportState"
        InitialViewportStateEvent.handle(event, @ui.iframe)
        break

  initUI: ->
    @ui = {
      mousePointer: @document.getElementById("themouse")
      iframe: @document.getElementById("theframe")
    }
    @simulationDocument = @ui.iframe.contentDocument


module.exports = ReplaySimulator
