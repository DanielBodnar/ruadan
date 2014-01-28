define([
  'lodash'
  'recording/recorder'
  'recording/recorder_client'
], (
  _
  Recorder
  RecorderClient
)->
  recorder = new Recorder(
    document: document
    rootElement: document.getElementsByTagName("html")[0]
    Client: RecorderClient
  )

  recorder.startRecording()
)
