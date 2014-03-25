Recorder = require('./recording/recorder.coffee')
RecorderClient = require('./recording/recorder_client.coffee')

recorder = new Recorder(
  document: document
  rootElement: document.getElementsByTagName("html")[0]
  Client: RecorderClient
)

recorder.startRecording(document.title, "New Recorder", true)

module.exports = recorder

