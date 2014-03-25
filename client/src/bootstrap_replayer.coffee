Player = require('./replaying/player/player.coffee')
EventDeserializer = require('./events/deserializer.coffee')

doReplay = (events) ->
  events = events.map( (event) ->
    EventDeserializer.deserialize(event)
  )
  firstEventTimestamp = events[0].timestamp
  events.forEach((event) ->
    event.timestamp -= firstEventTimestamp
  )
  player = new Player(events, document)
  player.start()

request = new XMLHttpRequest()
request.open('GET', "http://127.0.0.1:3000/view?sessionId=#{window.ruadanSessionId}", true)

request.onload = ->
  if (request.status >= 200 && request.status < 400)
    data = JSON.parse(request.responseText)
    doReplay(data.events)
  else
    console.error("error requesting info from the server", request)

request.onerror = ->
  console.error("error requesting info from the server", request)

request.send()
