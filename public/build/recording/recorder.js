(function() {
  define(['lodash', 'recording/observers/mutation_observer', 'recording/observers/mouse_observer', 'recording/observers/scroll_observer', 'recording/observers/viewport_observer', 'recording/observers/text_selection_observer'], function(_, MutationObserver, MouseObserver, ScrollObserver, ViewportObserver, TextSelectionObserver) {
    var Recorder;
    return Recorder = (function() {
      function Recorder(options) {
        this.rootElement = options.rootElement;
        this.client = new options.Client(options.document, this.rootElement);
        this.observers = {
          mutation: new MutationObserver(),
          mouse: new MouseObserver(),
          scrolling: new ScrollObserver(),
          viewport: new ViewportObserver(),
          selection: new TextSelectionObserver()
        };
        this._bindObserverEvents(this.observers);
        this.initialize();
      }

      Recorder.prototype.initialize = function() {
        this.observers.scrolling.initialize(window);
        this.observers.mutation.initialize(this.rootElement);
        this.observers.mouse.initialize(window);
        this.observers.viewport.initialize(this.rootElement);
        return this.observers.selection.initialize(document);
      };

      Recorder.prototype.startRecording = function() {
        return _.each(this.observers, function(v, _) {
          return v.observe();
        });
      };

      Recorder.prototype.stopRecording = function() {
        return _.each(this.observers, function(v, _) {
          return v.disconnect();
        });
      };

      Recorder.prototype._processSelectionObject = function(data, fn) {
        if (data.anchorNode) {
          data.anchorNode = this.observers.mutation.serializer.knownNodesMap.get(data.anchorNode);
        }
        if (data.focusNode) {
          data.focusNode = this.observers.mutation.serializer.knownNodesMap.get(data.focusNode);
        }
        return fn(data);
      };

      Recorder.prototype._bindObserverEvents = function(observers) {
        var _this = this;
        observers.scrolling.on('initialize', function(info) {
          return _this.client.setInitialScrollState(info);
        });
        observers.scrolling.on('scroll', function(info) {
          return _this.client.onScroll(info);
        });
        observers.mutation.on('initialize', this.client.setInitialMutationState.bind(this.client));
        observers.mutation.on('change', this.client.onMutation.bind(this.client));
        observers.viewport.on('initialize', function(info) {
          return _this.client.setInitialViewportState(info);
        });
        observers.selection.on('initialize', function(data) {
          return _this._processSelectionObject(data, _this.client.setInitialSelection.bind(_this.client));
        });
        observers.selection.on('select', function(data) {
          return _this._processSelectionObject(data, _this.client.onSelect.bind(_this.client));
        });
        return observers.mouse.on('mouse_moved', function(position) {
          return _this.client.onMouseMove(position);
        });
      };

      return Recorder;

    })();
  });

}).call(this);
