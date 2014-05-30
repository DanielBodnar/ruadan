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

  hasEventsForTargetTimestamp: (targetTimestamp)->
    eventsToRun = @_getEventsInRange(@lastPlayedTimestamp, targetTimestamp)
    eventsToRun.length>0

  runToTimestamp: (targetTimestamp) ->
    @resetDocument() if (targetTimestamp < @lastPlayedTimestamp)

    eventsToRun = @_getEventsInRange(@lastPlayedTimestamp, targetTimestamp)

    @_runEvents(eventsToRun)

    @lastPlayedTimestamp = targetTimestamp

    if @lastPlayedTimestamp >= @getLastTimestamp(@events)
      @emit("simulationEnd")

  _getEventsInRange: (start, end) ->
    _(@events)
    .filter((event)->
      start == null || event.timestamp > start
    ).filter((event)->
      end == null || event.timestamp <= end
    ).value()

  _runEvents: (events) ->
    events.forEach( (event) =>
      @desktop.getWindow(event.getWindowId()).runEvent(event)
    )

  getLastTimestamp: (events)->
    events[events.length - 1].timestamp



module.exports = ReplaySimulator
