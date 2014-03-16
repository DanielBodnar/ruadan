EventStore = require_app("lib/redis_event_store")
_ = require('lodash')

class Event
  constructor: (action, timestamp, eventData) ->
    @attributes =
      action: action
      timestamp: timestamp
      data: eventData

  @eventsFromRequestJSON: (events) ->
    events = [events] unless _.isArray(events)
    events.map((eData) =>
      @fromJSON(eData)
    )

  toJSON: ->
    @attributes

  @fromJSON: (jsonObj) ->
    new Event(jsonObj.action, jsonObj.timestamp, jsonObj.data)

module.exports = Event
