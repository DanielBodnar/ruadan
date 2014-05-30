class Timer
  constructor: (running = true) ->
    @currentTime = 0
    @speedMultiplier = 1
    @running = running

  getTime: ->
    @currentTime

  addTime: (delta) ->
    if (@running)
      @currentTime += delta * @speedMultiplier

  setTime: (time) ->
    @currentTime = time

  resume: ->
    @running = true

  pause: ->
    @running = false

  setMultiplier: (multiplier) ->
    @speedMultiplier = multiplier

module.exports = Timer
