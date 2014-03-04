RedisEventStore = rek('lib/redis_event_store')
Promise = require("bluebird")

describe 'RedisEventStore', ->
  sandbox = sinon.sandbox.create()

  afterEach ->
    sandbox.restore()

  before ->

  describe 'getClient', ->
    it 'should return a promise', ->
      expect(RedisEventStore.getClient()).to.be.ok
