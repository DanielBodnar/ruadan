Player = require('./replaying/player/player.coffee')
EventDeserializer = require('./events/deserializer.coffee')


prepareEvents = (events)->
  events = events.map( (event) ->
    EventDeserializer.deserialize(event)
  )
  firstEventTimestamp = events[0].timestamp
  # TODO: fix to work without mutating the original object, this is a weird stuff right here
  events.forEach((event) ->
    event.timestamp -= firstEventTimestamp
  )
  events

doReplay = (events, document) ->
  events = prepareEvents(events)
  player = new Player(events, document)
  player.start()

getEvents = (session, document, cb)->
  request = new XMLHttpRequest()
  request.open('GET', "http://127.0.0.1:3000/view?sessionId=#{session}", true)

  request.onload = ->
    if (request.status >= 200 && request.status < 400)
      data = JSON.parse(request.responseText)
      cb(data.events, document)
    else
      console.error("error requesting info from the server", request)

  request.onerror = ->
    console.error("error requesting info from the server", request)

  request.send()


module.exports = window.bootstrapReplayer = {
  start: (session, document)-> getEvents(session, document, doReplay)
  prepareEvents: prepareEvents
}