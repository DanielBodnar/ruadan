EventStore = require_app("lib/redis_event_store")
_ = require('lodash')

class Event
  constructor: (action, timestamp, eventData) ->
    @attributes =
      action: action
      timestamp: timestamp
      data: eventData

  @eventsFromRequestJSON: (action, data) ->
    data = [data] unless _.isArray(data)
    data.map((eData) ->
      new Event(action, eData.timestamp, eData)
    )

  toJSON: ->
    @attributes

  @fromJSON: (jsonObj) ->
    new Event(jsonObj.action, jsonObj.timestamp, jsonObj.data)

module.exports = Event
