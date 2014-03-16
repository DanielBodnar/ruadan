class Event
  action: "none"

  constructor: (@data, @timestamp = new Date().getTime()) ->

  toJson: ->
    {
      action: @action,
      data: @_serializeData(),
      timestamp: @timestamp
    }

  _serializeData: ->
    @data

module.exports = Event
