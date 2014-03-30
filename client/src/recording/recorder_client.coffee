class RecorderClient
  # this class is not static because it might be a good idea to add event queue management here.
  newSession: (name, callback = ->) ->
    @_postRequest("start", { name: name }, (errorMessage, response) ->
      if errorMessage?
        errorMessage = "Error while creating session: #{errorMessage}"
        callback(errorMessage)
      else
        sessionId = JSON.parse(response).sessionId
        if (sessionId?)
          console.log("starting session #{sessionId}")
          callback(null, sessionId)
        else
          callback("Bad sessionId")
    )

  endSession: (sessionId, callback=->) ->
    @_postRequest("end", { sessionId: sessionId }, (errorMessage, response) ->
      errorMessage = "Error while ending callback: #{errorMessage}" if errorMessage?
      callback(errorMessage)
    )

  recordEvent: (sessionId, event, callback) ->
    @_postRequest("record", { sessionId: sessionId, events: [event.toJson()] }, (errorMessage) ->
      console.error("error recording event", errorMessage) if errorMessage?
      callback(errorMessage)
    )

  _postRequest: (path, data, callback) ->
    request = new XMLHttpRequest()
    request.open('POST', "http://127.0.0.1:3000/" + path, true)
    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8")

    request.onload = (e) ->
      if (request.status == 200)
        callback(null, request.responseText) if callback
      else
        callback(request.status) if callback

    request.onerror = ->
      callback(request.status) if callback

    request.send(JSON.stringify(data))

module.exports = RecorderClient
