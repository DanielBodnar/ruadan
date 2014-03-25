class EventHandler
  action: "none"

  canHandle: (event) ->
    event.action == @action

  handle: (event) ->
    console.error("Can't handle event", event)
    throw new Exception("Can't handle event: " + event.action)

module.exports = EventHandler
