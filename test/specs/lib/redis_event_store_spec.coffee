RedisEventStore = rek('lib/redis_event_store')
Promise = require("bluebird")
Redis = require('redis')
ShortId = require('shortid')
_ = require('lodash')

expect = chai.expect

describe 'RedisEventStore', ->
  @timeout(500)

  beforeEach ->
    @sandbox = sinon.sandbox.create()

  afterEach ->
    @sandbox.restore()

  it_should_return_a_promise = (func) ->
    it 'should return a promise', ->
      promise = func()
      expect(promise).to.be.an.instanceof(Promise)
      promise.catch( -> )

  startSession = (name = "name", timestamp = "12345") ->
    RedisEventStore.startSession(name, timestamp)

  describe 'startSession', ->
    sessionId = "someSessionId"

    beforeEach ->
      @sandbox.stub(ShortId, "generate").returns(sessionId)

    it_should_return_a_promise(RedisEventStore.startSession)

    it 'should return a new session id', ->
      promise = startSession()
      expect(promise).to.eventually.equal(sessionId)

  describe 'getSessions', ->
    it_should_return_a_promise(RedisEventStore.getSessions)
    it 'should return all sessions', ->
      Promise.all([
        startSession("session1")
        startSession("session2")
      ]).then( ->
        promise = RedisEventStore.getSessions().then( (sessions) ->
          sessions.map( (session) ->
            session.name
          )
        )
        expect(promise).to.eventually.contain("session1").and.contain("session2")
      )

  context 'when given a sessionId', ->
    beforeEach ->
      @sessionName = "name"
      @sessionTimestamp = new Date().getTime()
      startSession(@sessionName, @sessionTimestamp).then( (@sessionId) =>)

    describe 'endSession', ->
      it_should_return_a_promise(RedisEventStore.endSession)
      it 'should add endTimestamp to session', ->
        expect(RedisEventStore.getSession(@sessionId)).to.eventually.not.have.property("endTimestamp").then( =>
          RedisEventStore.endSession(@sessionId, new Date().getTime()).then( =>
            expect(RedisEventStore.getSession(@sessionId)).to.eventually.have.property("endTimestamp")
          )
        )

    describe 'getSession', ->
      it_should_return_a_promise(RedisEventStore.getSession)
      it 'should return a previously started session', ->
        expect(RedisEventStore.getSession(@sessionId)).to.eventually.deep.equal({
          id: @sessionId,
          name: @sessionName,
          startTimestamp: @sessionTimestamp.toString()
        })

    describe 'recordEvent', ->
      beforeEach ->
        @event = { attributes: { timestamp: "1234", action: "test" } }
        RedisEventStore.recordEvent(@sessionId, @event.attributes.timestamp, @event)

      it_should_return_a_promise(RedisEventStore.recordEvent)
      it "should add the event to the session's event list", ->
        promise = RedisEventStore.getEvents(@sessionId).then( (results) -> results.map(JSON.parse) )
        expect(promise).to.eventually.deep.equal([@event])

    describe 'getEvents', ->
      it_should_return_a_promise(RedisEventStore.getEvents)
      it "should return all events that belong to a session", ->
        event1 = { attributes: { timestamp: "1234", action: "test" } }
        event2 = { attributes: { timestamp: "1235", action: "test" } }
        event3 = { attributes: { timestamp: "1236", action: "test" } }
        event4 = { attributes: { timestamp: "1237", action: "test" } }
        startSession("session1").then( (sessionId) ->
          Promise.all([
            RedisEventStore.recordEvent(sessionId, event1.attributes.timestamp, event1)
            RedisEventStore.recordEvent(sessionId, event2.attributes.timestamp, event2)
            RedisEventStore.recordEvent(sessionId, event3.attributes.timestamp, event3)
            RedisEventStore.recordEvent(sessionId, event4.attributes.timestamp, event4)
          ]).then( ->
            expect(RedisEventStore.getEvents(sessionId)).to.eventually.have.length(4)
          )
        )
