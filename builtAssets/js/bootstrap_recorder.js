(function() {
  define(['lodash', 'recording/recorder', 'recording/recorder_client'], function(_, Recorder, RecorderClient) {
    var recorder;
    recorder = new Recorder({
      document: document,
      rootElement: document.getElementsByTagName("html")[0],
      Client: RecorderClient
    });
    return recorder.startRecording();
  });

}).call(this);
