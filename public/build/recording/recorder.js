(function() {
  define(['recording/observers/mutation_observer', 'recording/observers/mouse_observer'], function(MutationObserver, MouseObserver) {
    var Recorder;
    return Recorder = (function() {
      function Recorder(options) {
        this.client = options.client;
        this.rootElement = options.rootElement;
        this.mutationObserver = new MutationObserver();
        this.mouseObserver = new MouseObserver();
        this._bindObserverEvents();
      }

      Recorder.prototype.initialize = function() {
        this.client.setViewportHeight(document.documentElement.clientHeight);
        this.client.setViewportWidth(document.documentElement.clientWidth);
        return this.client.initialize(this.rootElement);
      };

      Recorder.prototype.startRecording = function() {
        this.mutationObserver.observe(this.rootElement);
        return this.mouseObserver.observe(this.rootElement);
      };

      Recorder.prototype.stopRecording = function() {
        this.mutationObserver.disconnect();
        return this.mouseObserver.disconnect();
      };

      Recorder.prototype._bindObserverEvents = function() {
        var _this = this;
        this.mutationObserver.on('change', function(mutations) {
          return _this.client.onChange(mutations);
        });
        return this.mouseObserver.on('change', function(data) {
          return console.log("mouse moved", data.x, data.y);
        });
      };

      return Recorder;

    })();
  });

}).call(this);
