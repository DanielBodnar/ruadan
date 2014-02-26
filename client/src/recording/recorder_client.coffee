class RecorderClient
  constructor: (@document, @rootElement)->

  setInitialMutationState: (data)->
    @_record("initialMutationState", data)

  setInitialScrollState: (data)->
    @_record("initialScrollState", data)

  setInitialViewportState: (data)->
    @_record("initialViewportState", data)

  setInitialSelection: (selection)->
    @_record("initialSelectState", selection)

  onSelect: (selection) ->
    @_record("select", selection)

  onMutation: (data)->
    @_record("mutation", data)

  onMouseMove: (data)->
    @_record("mouse", data)

  onScroll: (data) ->
    @_record("scroll", data)

  _record: (action, data) ->
    console.log("recording ",action)

    request = new XMLHttpRequest();
    request.open('POST', "http://127.0.0.1:3000/record", true)

    dataToSend = JSON.stringify({ action: action, data: data })

    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8")

    request.onload = ->
      if !(request.status >= 200 && request.status < 400)
        console.error("error requesting info from the server", request)

    request.onerror = ->
      console.error("error requesting info from the server", request)

    request.send(dataToSend)

module.exports = RecorderClient