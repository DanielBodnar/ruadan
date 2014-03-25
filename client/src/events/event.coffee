class Event
  action: "none"

  constructor: (@data, @timestamp = new Date().getTime()) ->

  toJson: ->
    {
      action: @action,
      data: @_serializeData(),
      timestamp: @timestamp
    }

  @fromJson: (json) ->
    event = new this()
    event.action = json.action
    event.data = @_deserializeData(json.data)
    event.timestamp = json.timestamp
    event

  _serializeData: ->
    @data

  @_deserializeData: (data) ->
    data

module.exports = Event
