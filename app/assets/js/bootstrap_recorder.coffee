define([
  'lodash'
  'recording/recorder'
  'recording/recorder_client'
], (
  _
  Recorder
  RecorderClient
)->
  client = new RecorderClient(document)
  recorder = new Recorder(
    rootElement: document.getElementsByTagName("html")[0],
    client: client
  )
  recorder.initialize()
#  recorder.startRecording()
)
