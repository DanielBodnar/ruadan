request = require('superagent')
Promise = require('bluebird')
RecorderClient = require('../../../client/src/recording/recorder_client.coffee')
newPageJson = require("../../fixtures/server/new_page_event.json")
newPageEvent = { toJson: -> newPageJson }

class EventGenerator
  constructor: (@client, @idx) ->

  run: ->
    console.log(JSON.stringify(newPageEvent.toJson()))
    promise = Promise.defer()
    startTime = new Date().getTime()
    @client.newSession("session #{@idx}", (error, sessionId) =>
      console.error(error, sessionId)
      @client.recordEvent(sessionId, newPageEvent, (error) =>
        console.error(error)
        @client.endSession(sessionId, (error) =>
          console.error(error)
          endTime = new Date().getTime()
          promise.resolve("session #{@idx} finished in #{endTime - startTime}ms")
        )
      )
    )
    promise

describe "stress test", ->

  beforeEach ->
    sandbox = sinon.sandbox.create()
    sandbox.stub(RecorderClient::, "_postRequest", (path, data, callback = ->) ->
      request.post(@endpoint + path)
             .set("Content-Type", "application/json;charset=UTF-8")
             .send(JSON.stringify(data))
             .end( (error, response) ->
               callback(error, response?.res?.text)
             )
    )
    @client = new RecorderClient("http://rlocal.giftsproject.com/")

  afterEach ->
    #sandbox.restore()

  it "should handle 50 simulataneous clients", ->
    eventGenerators = []
    for i in [0..0]
      eventGenerators.push(new EventGenerator(@client, i).run())
    Promise.all(eventGenerators).then( (results) ->
      for result in results
        console.log(result)
    )
