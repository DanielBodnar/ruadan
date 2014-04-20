baseUrl = require('build_config/base_url.coffee')
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

  continueSession: (sessionId, callback = ->) ->
    @_postRequest("continue", { sessionId: sessionId }, (errorMessage, response) ->
      errorMessage = "Error continuing session: " + errorMessage if errorMessage?
      callback(errorMessage, JSON.parse(response))
    )

  endSession: (sessionId, callback = ->) ->
    @_postRequest("end", { sessionId: sessionId }, (errorMessage, response) ->
      errorMessage = "Error while ending callback: #{errorMessage}" if errorMessage?
      callback(errorMessage)
    )

  recordEvent: (sessionId, event, callback = ->) ->
    @_postRequest("record", { sessionId: sessionId, events: [event.toJson()] }, (errorMessage) ->
      console.error("error recording event", errorMessage) if errorMessage?
      callback(errorMessage)
    )

  _postRequest: (path, data, callback = ->) ->
    request = new XMLHttpRequest()
    request.open('POST', "#{baseUrl}/" + path, true)
    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8")

    request.onload = (e) ->
      if (request.status == 200)
        callback(null, request.responseText)
      else
        callback(request.status)

    request.onerror = ->
      callback(request.status)

    request.send(JSON.stringify(data))

module.exports = RecorderClient
