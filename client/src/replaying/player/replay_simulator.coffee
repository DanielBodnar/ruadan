_ = require('lodash')
EventEmitter = require('eventemitter').EventEmitter
Desktop = require('./simulation/desktop.coffee')

class ReplaySimulator extends EventEmitter
  constructor: (@events, @document) ->
    @desktop = new Desktop(@document, @document.body)
    @resetDocument()

  resetDocument: ->
    @lastPlayedTimestamp = null
    @desktop.closeAllWindows()
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
      @desktop.getWindow(event.getWindowId()).runEvent(event)
    )

module.exports = ReplaySimulator
