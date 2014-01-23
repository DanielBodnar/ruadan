(function() {
  define(['lodash', 'recording/recorder', 'recording/recorder_client'], function(_, Recorder, RecorderClient) {
    var client, recorder;
    client = new RecorderClient(document);
    recorder = new Recorder({
      rootElement: document.getElementsByTagName("html")[0],
      client: client
    });
    recorder.initialize();
    return recorder.startRecording();
  });

}).call(this);
