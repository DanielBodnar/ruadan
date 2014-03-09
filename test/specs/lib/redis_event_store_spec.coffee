RedisEventStore = rek('lib/redis_event_store')
Fixtures = rek('test/fixtures/lib/redis_event_store_fixtures')
Promise = require("bluebird")
Redis = require('redis')
_ = require('lodash')

expect = chai.expect

describe 'RedisEventStore', ->
  sandbox = sinon.sandbox.create()

  myStubClient = Redis.createClient()

  # accepts a promise which should return an array of session data and a matching array of session data
  # and checks that they match
  expectSessionsToBeEqual = (promise, sessions) ->
    sessionData = sessions.map((sessionId) ->
      sessionId: sessionId
      timestamp: Fixtures.DB['session:' + sessionId][0].score
    )

    expect(promise).to.eventually.deep.equal(sessionData)

  beforeEach ->
    sandbox.stub(Redis, "createClient").returns(myStubClient)

  afterEach ->
    sandbox.restore()

  it_should_return_a_promise = (func) ->
    it 'should return a promise', ->
      expect(func()).to.be.an.instanceof(Promise)

  stub_zrange_by_score = ->
    stub = sandbox.stub(myStubClient, 'zrangebyscore')
    for i in [0...3]
      stub = stub
        .withArgs('session:' + Fixtures.DB.sessions[i], 0, '+inf', 'withscores', 'limit', 0, 1)
        .yields(null, ['session:' + Fixtures.DB.sessions[i],
                       Fixtures.DB['session:' + Fixtures.DB.sessions[i]][0].score])


  describe 'startSession', ->
    beforeEach =>
      @saddStub = sandbox.stub(myStubClient, 'sadd').yields()

    it_should_return_a_promise(RedisEventStore.startSession)

    it 'should return a new session id', ->
      promise = RedisEventStore.startSession()
      expect(promise).to.eventually.be.a('string').that.is.not.empty

    it 'should create the session in the database', =>
      RedisEventStore.startSession().then( (result) =>
        expect(@saddStub).to.have.been.calledWith('sessions', result)
      )

  describe 'getSessionsForIds', ->

    beforeEach ->
      stub_zrange_by_score()

    it_should_return_a_promise ->
      RedisEventStore.getSessionsForIds([])

    it 'should return an empty array for an empty input array', ->
      promise = RedisEventStore.getSessionsForIds([])
      expect(promise).to.eventually.be.empty

    it 'should return the session data for a subset of the sessions', ->
      sessionIds = Fixtures.DB.sessions.slice(0,2)
      expectSessionsToBeEqual(RedisEventStore.getSessionsForIds(sessionIds), sessionIds)

    it 'should return the session data for all of the sessions', ->
      expectSessionsToBeEqual(RedisEventStore.getSessionsForIds(Fixtures.DB.sessions), Fixtures.DB.sessions)


  describe 'getSessionForId', ->

    beforeEach ->
      stub_zrange_by_score()

    it_should_return_a_promise ->
      RedisEventStore.getSessionForId(Fixtures.DB.sessions[0])

    it 'should return the session data', ->
      promise = RedisEventStore.getSessionForId(Fixtures.DB.sessions[0])

      expect(promise).to.eventually.deep.equal
        sessionId: Fixtures.DB.sessions[0]
        timestamp: Fixtures.DB['session:' + Fixtures.DB.sessions[0]][0].score


  describe 'getSessions', ->

    beforeEach ->
      stub_zrange_by_score()
      smembersStub = sandbox.stub(myStubClient, 'smembers').yields(null, Fixtures.DB.sessions)

    it_should_return_a_promise(RedisEventStore.getSessions)

    it 'should return all sessions', ->
      promise = RedisEventStore.getSessions()
      expectSessionsToBeEqual(promise, Fixtures.DB.sessions)

  describe 'recordEvent', ->
    beforeEach =>
      @zaddStub = sandbox.stub(myStubClient, 'zadd').yields()

    it_should_return_a_promise ->
      retval = RedisEventStore.recordEvent(Fixtures.DB.sessions[0], 1500, Fixtures.MOCK_EVENT)

    it 'should record the event', =>
      sessionId = Fixtures.DB.sessions[0]
      RedisEventStore.recordEvent(sessionId, 1500, Fixtures.MOCK_EVENT).then((result) =>
        expect(@zaddStub).to.have.been.calledWith('session:' + sessionId, 1500, JSON.stringify(Fixtures.MOCK_EVENT))
      )

  describe 'getEvents', ->
    beforeEach =>
      @sessionId = Fixtures.DB.sessions[0]
      stub = sandbox.stub(myStubClient, 'zrangebyscore')
             .withArgs('session:' + @sessionId, 0, '+inf')
             .yields(null, Fixtures.DB['session:' + @sessionId].map((ev) -> ev.data))

    it_should_return_a_promise ->
      RedisEventStore.getEvents(Fixtures.DB.sessions[0])

    it 'should get the events for a session', =>
      promise = RedisEventStore.getEvents(@sessionId)
      expect(promise).to.eventually.deep.equal(Fixtures.DB['session:' + @sessionId].map((ev) -> ev.data))

  describe 'isDOMInitialized', ->

    beforeEach ->
      sandbox.stub(myStubClient, 'get')
        .withArgs('session:' + Fixtures.DB.sessions[0] + ':domInited').yields(null, 'true')
        .withArgs('session:' + Fixtures.DB.sessions[1] + ':domInited').yields(null, 'false')
        .withArgs('session:kuku'                       + ':domInited').yields(null, '')

    it_should_return_a_promise ->
      RedisEventStore.getEvents(Fixtures.DB.sessions[0])

    it 'should return true for an initialized session', ->
      promise = RedisEventStore.isDOMInitialized(Fixtures.DB.sessions[0])
      expect(promise).to.eventually.be.true

    it 'should return false for an uninitialized session', ->
      promise = RedisEventStore.isDOMInitialized(Fixtures.DB.sessions[1])
      expect(promise).to.eventually.be.false

    it 'should return false for a non-existing session', ->
      promise = RedisEventStore.isDOMInitialized('kuku')
      expect(promise).to.eventually.be.false

  describe 'markDOMInitialized', ->
    beforeEach =>
      @setStub = sandbox.stub(myStubClient, 'set').yields()

    it_should_return_a_promise ->
      RedisEventStore.markDOMInitialized(Fixtures.DB.sessions[0])

    it 'should mark the session initialized', =>
      promise = RedisEventStore.markDOMInitialized(Fixtures.DB.sessions[0])
      promise.then( =>
        expect(@setStub).to.have.been.calledWith('session:' + Fixtures.DB.sessions[0] + ":domInited", true)
      )