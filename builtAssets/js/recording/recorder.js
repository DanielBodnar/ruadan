(function() {
  define(['lodash', 'recording/observers/mutation_observer', 'recording/observers/mouse_observer', 'recording/observers/scroll_observer', 'recording/observers/viewport_observer'], function(_, MutationObserver, MouseObserver, ScrollObserver, ViewportObserver) {
    var Recorder;
    return Recorder = (function() {
      function Recorder(options) {
        this.rootElement = options.rootElement;
        this.client = new options.Client(options.document, this.rootElement);
        this.observers = {
          mutation: new MutationObserver(),
          mouse: new MouseObserver(),
          scrolling: new ScrollObserver(),
          viewport: new ViewportObserver()
        };
        this._bindObserverEvents(this.observers);
        this.initialize();
      }

      Recorder.prototype.initialize = function() {
        this.observers.scrolling.initialize(window);
        this.observers.mutation.initialize(this.rootElement);
        this.observers.mouse.initialize(this.rootElement);
        return this.observers.viewport.initialize(this.rootElement);
      };

      Recorder.prototype.startRecording = function() {
        return _.each(this.observers, function(v, k) {
          return v.observe();
        });
      };

      Recorder.prototype.stopRecording = function() {
        return _.each(this.observers, function(v, k) {
          return v.disconnect();
        });
      };

      Recorder.prototype._bindObserverEvents = function(observers) {
        var _this = this;
        observers.scrolling.on('initialize', function(info) {
          return _this.client.setInitialScrollState(info);
        });
        observers.scrolling.on('scroll', function(info) {
          return _this.client.onScroll(info);
        });
        observers.mutation.on('initialize', function(info) {
          return _this.client.setInitialMutationState(info);
        });
        return observers.viewport.on('initialize', function(info) {
          return _this.client.setInitialViewportState(info);
        });
      };

      return Recorder;

    })();
  });

}).call(this);
