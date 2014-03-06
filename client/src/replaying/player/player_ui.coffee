EventEmitter = require('eventemitter').EventEmitter

class PlayerUI extends EventEmitter

  actionColors: {
    "mouse": "yellow"
    "scroll": "green"
    "select": "blue"
    "mutation": "red"
    "initialMutationState": "magenta"
    "initialScrollState": "lime"
    "initialViewportState": "navy"
  }

  constructor: (@events, @document) ->
    @progress = 0
    @loopState = false
    @speed = 1

    @initUI()
    @bindUIEvents()

  setCurrentTime: (time) ->
    @ui.seekBar.value = time
    @ui.timeDisplay.innerHTML = (time / 1000.0).toFixed(2)

  setLoopState: (loopState) ->
    if (loopState)
      @ui.loopState.classList.add("loop")
    else
      @ui.loopState.classList.remove("loop")

  setSpeed: (speed) ->
    @ui.speed.value = speed

  play: ->
    @ui.playPause.classList.remove("play")
    @ui.playPause.classList.add("pause")

  pause: ->
    @ui.playPause.classList.remove("pause")
    @ui.playPause.classList.add("play")

  initUI: ->
    container = @document.getElementById("player_wrapper")
    @ui = {
      container: container
      totalTime: container.querySelector(".total_time")
      seekBar: container.querySelector(".seek_bar")
      timeDisplay: container.querySelector(".time_display")
      loopState: container.querySelector(".loop_state")
      speed: container.querySelector(".speed")
      playPause: container.querySelector(".play_pause")
      markersContainer: container.querySelector(".markers_container")
    }

    @ui.totalTime.innerHTML = (@calculateTotalTime() / 1000.0).toFixed(2)
    @ui.seekBar.min = 0
    @ui.seekBar.max = @calculateTotalTime()
    @ui.seekBar.step = 1
    @drawMarkers()

  drawMarkers: ->
    @events.forEach( (event) =>
      @ui.markersContainer.appendChild(@createMarker(event))
    )

  createMarker: (event) ->
    containerWidth = parseInt(getComputedStyle(@ui.markersContainer)["width"], 10)
    leftOffset = event.timestamp / @calculateTotalTime() * containerWidth
    element = @document.createElement("div")
    element.className = "marker"
    element.style.left = "#{leftOffset}px"
    element.classList.add(event.action)
    element

  bindUIEvents: ->
    @ui.playPause.addEventListener("click", =>
      if (@ui.playPause.classList.contains("play"))
        @emit("play")
      else if (@ui.playPause.classList.contains("pause"))
        @emit("pause")
    )

    @ui.seekBar.addEventListener("change", =>
      @emit("seek", parseInt(@ui.seekBar.value, 10))
    )

    @ui.loopState.addEventListener("click", =>
      @emit("toggleLoop")
    )

    @ui.speed.addEventListener("change", =>
      @emit("speed", parseFloat(@ui.speed.value))
    )

  calculateTotalTime: ->
    @events[@events.length - 1].timestamp

module.exports = PlayerUI
