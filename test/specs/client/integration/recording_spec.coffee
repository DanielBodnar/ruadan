fixtures = require('js-fixtures')
Recorder = require('../../../../client/src/recording/recorder.coffee')
Replayer = require('../../../../client/src/bootstrap_replayer.coffee')
ReplaySimulator = require('../../../../client/src/replaying/player/replay_simulator.coffee')
jade = require('jade')

events = []

class RecorderClient
  recordEvent: (sessionId, event, callback)->
    events.push(event)
    callback(null)
  newSession: (name, callback = ->)->
    callback(null, "aaa")
  endSession: (sessionId, callback=->)->
    callback(null)


fixturesDocument = ->
  fixtures.window().document
describe 'recording replaying integration tests', ->

  beforeEach ->
    fixtures.load('basic.html')
    @sandbox = sinon.sandbox.create()

    @recorder = new Recorder(
      document: fixturesDocument()
      rootElement: fixturesDocument().getElementsByTagName("html")[0]
      Client: RecorderClient
    )

    @recorder.startRecording(fixturesDocument().title, "New Recorder", true)

  afterEach ->
    fixtures.cleanUp()
    @sandbox.restore()

  describe "remove/add weird state", ->
    it 'should replay the state correctly', ->
      father = fixturesDocument().createElement('div')
      father.setAttribute('class', 'a')
      father.innerHTML = '<div class="b"><div class="c"></div></div>'
      fixturesDocument().body.appendChild(father)

      son = fixturesDocument().querySelectorAll(".c")[0]

      son = son.parentNode.removeChild(son)
      father.appendChild(son)
      @recorder.observers.mutation.flush()
      fixtures.cleanUp()
      fixtures.load('basic_replayer.html')
      events = Replayer.prepareEvents(events)
      simulator = new ReplaySimulator(events, fixturesDocument())
      expect(->simulator.runEvents(events)).to.not.throw()
      expect(father.innerHTML).to.equal('<div class="b"></div><div class="c"></div>')


