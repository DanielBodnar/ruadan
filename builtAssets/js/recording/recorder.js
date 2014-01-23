(function() {
  define(['recording/observers/mutation_observer', 'recording/observers/mouse_observer', 'recording/observers/scroll_observer', 'recording/observers/viewport_observer'], function(MutationObserver, MouseObserver, ScrollObserver, ViewportObserver) {
    var Recorder;
    return Recorder = (function() {
      function Recorder(options) {
        this.client = options.client;
        this.rootElement = options.rootElement;
        this.mutationObserver = new MutationObserver();
        this.mouseObserver = new MouseObserver();
        this.scrollingObserver = new ScrollObserver();
        this.viewportObserver = new ViewportObserver();
        this._bindObserverEvents();
      }

      Recorder.prototype.initialize = function() {
        this.scrollingObserver.initialize(window);
        this.mutationObserver.initialize(this.rootElement);
        this.mouseObserver.initialize(this.rootElement);
        this.viewportObserver.initialize(this.rootElement);
        return this.client.initialize(this.rootElement);
      };

      Recorder.prototype.startRecording = function() {
        this.mutationObserver.observe(this.rootElement);
        this.scrollingObserver.observe(this.rootElement);
        return this.mouseObserver.observe(this.rootElement);
      };

      Recorder.prototype.stopRecording = function() {
        this.mutationObserver.disconnect();
        this.scrollingObserver.disconnect();
        return this.mouseObserver.disconnect();
      };

      Recorder.prototype._bindObserverEvents = function() {
        var _this = this;
        this.scrollingObserver.on('initialize', function(info) {
          return _this.client.setInitialScrollState(info);
        });
        this.scrollingObserver.on('scroll', function(info) {
          return _this.client.onScroll(info);
        });
        this.mutationObserver.on('initialize', function(info) {
          return _this.client.setInitialMutationState(info);
        });
        return this.viewportObserver.on('initialize', function(info) {
          return _this.client.setInitialViewportState(info);
        });
      };

      return Recorder;

    })();
  });

}).call(this);
