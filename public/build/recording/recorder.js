(function() {
  define([], function() {
    var Recorder;
    return Recorder = (function() {
      function Recorder(options) {
        this.client = options.client;
        this.rootElement = options.rootElement;
        this._bindObserverEvents();
      }

      Recorder.prototype.initialize = function() {
        this.client.setViewportHeight(document.documentElement.clientHeight);
        this.client.setViewportWidth(document.documentElement.clientWidth);
        return this.client.initialize(this.rootElement);
      };

      Recorder.prototype.startRecording = function() {};

      Recorder.prototype.stopRecording = function() {};

      Recorder.prototype._bindObserverEvents = function() {};

      return Recorder;

    })();
  });

}).call(this);
