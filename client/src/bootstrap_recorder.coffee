Recorder = require('./recording/recorder.coffee')
RecorderClient = require('./recording/recorder_client.coffee')

window.ruadanRecorder = new Recorder(
  document: document
  rootElement: document.getElementsByTagName("html")[0]
  Client: RecorderClient
)

module.exports = window.ruadanRecorder

