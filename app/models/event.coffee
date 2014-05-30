EventStore = requireApp("lib/redis_event_store")
_ = require('lodash')

class Event
  constructor: (windowId, action, timestamp, eventData) ->
    @attributes =
      action: action
      timestamp: timestamp
      data: eventData
      windowId: windowId

  @eventsFromRequestJSON: (events) ->
    events = [events] unless _.isArray(events)
    events.map((eData) =>
      @fromJSON(eData)
    )

  toJSON: ->
    @attributes

  @fromJSON: ({action: action, timestamp: timestamp, data: data, windowId: windowId}) ->
    new Event(windowId, action, timestamp, data)

module.exports = Event
