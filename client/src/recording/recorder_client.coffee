class RecorderClient
  constructor: (@document, @rootElement, @sessionId) ->

  setInitialMutationState: (data) ->
    @_record("initialMutationState", data)

  setInitialScrollState: (data) ->
    @_record("initialScrollState", data)

  setInitialViewportState: (data) ->
    @_record("initialViewportState", data)

  setInitialSelection: (selection) ->
    @_record("initialSelectState", selection)

  onSelect: (selection) ->
    @_record("select", selection)

  onMutation: (data) ->
    @_record("mutation", data)

  onMouseClick: (data) ->
    @_record("mouse", data)

  onMouseMove: (data) ->
    @_record("mouse", data)

  onScroll: (data) ->
    @_record("scroll", data)

  startRecording: (callback) ->
    request = new XMLHttpRequest()
    request.open('POST', "http://127.0.0.1:3000/start", true)
    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8")

    request.onload = (e) =>
      @sessionId = JSON.parse(request.responseText).sessionId
      console.log('starting session ' + @sessionId)
      callback(@sessionId)

    request.send()

  _record: (action, data) ->
    console.log("recording ",action, data)

    request = new XMLHttpRequest()
    request.open('POST', "http://127.0.0.1:3000/record", true)

    dataToSend = JSON.stringify({ sessionId: @sessionId, action: action, data: data })

    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8")

    request.onload = ->
      if !(request.status >= 200 && request.status < 400)
        console.error("error requesting info from the server", request)

    request.onerror = ->
      console.error("error requesting info from the server", request)

    request.send(dataToSend)

module.exports = RecorderClient
