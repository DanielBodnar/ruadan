Timer = require('./timer.coffee')
PlayerUI = require('./player_ui.coffee')
EventDeserializer = require('../../events/deserializer.coffee')

ReplaySimulator = require('./replay_simulator.coffee')

class Player
  #event timestamps should start at 0
  constructor: (events, document) ->
    @timer = new Timer()
    @totalTime = events[events.length - 1].timestamp
    @playbackParams = {
      replayAfterEnd: false
    }
    @ui = new PlayerUI(events, document)
    @simulator = new ReplaySimulator(events, document)

  start: ->
    @initUI()
    @bindUIEvents()
    @bindSimulatorEvents()
    @lastTime = Date.now()
    @loop()

  loop: ->
    @update()
    setTimeout((=> @loop()), 0)

  play: ->
    if (@timer.getTime() >= @totalTime)
      @timer.setTime(0)
    @ui.play()
    @timer.resume()

  pause: ->
    @ui.pause()
    @timer.pause()

  update: ->
    @updateTimer()
    @simulator.runToTimestamp(@timer.getTime())
    @ui.setCurrentTime(@timer.getTime())

  updateTimer: ->
    currentTime = Date.now()
    @timer.addTime(currentTime - @lastTime)
    @lastTime = currentTime

  initUI: ->
    @ui.setLoopState(@playbackParams.replayAfterEnd)
    @ui.setSpeed(1)
    @ui.play()

  bindUIEvents: ->
    @ui.on("play", =>
      @play()
    )

    @ui.on("pause", =>
      @pause()
    )

    @ui.on("seek", (time) =>
      @timer.setTime(time)
    )

    @ui.on("speed", (speed) =>
      @ui.setSpeed(speed)
      @timer.setMultiplier(speed)
    )

    @ui.on("toggleLoop", =>
      @playbackParams.replayAfterEnd = !@playbackParams.replayAfterEnd
      @ui.setLoopState(@playbackParams.replayAfterEnd)
    )

  bindSimulatorEvents: ->
    @simulator.on("simulationEnd", =>
      if (!@playbackParams.replayAfterEnd)
        @pause()
      else
        @timer.setTime(0)
    )

  @prepareEvents: (events)->
    deserializedEvents = events.map( (event) ->
      EventDeserializer.deserialize(event)
    )

    firstEventTimestamp = deserializedEvents[0].timestamp
    deserializedEvents.forEach((event) ->
      event.timestamp -= firstEventTimestamp
    )
    deserializedEvents

module.exports = Player
