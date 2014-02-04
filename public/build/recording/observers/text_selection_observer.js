(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lodash', 'eventEmitter'], function(_, EventEmitter) {
    var TextSelectionObserver, _ref;
    return TextSelectionObserver = (function(_super) {
      var EVENT_NAME;

      __extends(TextSelectionObserver, _super);

      function TextSelectionObserver() {
        _ref = TextSelectionObserver.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      EVENT_NAME = 'selectionchange';

      TextSelectionObserver.prototype.initialize = function(element) {
        this.element = element;
        return this.trigger("initialize", [this._getSelection()]);
      };

      TextSelectionObserver.prototype.observe = function() {
        return this._listener = this.element.addEventListener(EVENT_NAME, this._onChange.bind(this), true);
      };

      TextSelectionObserver.prototype.disconnect = function() {
        return this.element.removeEventListener(EVENT_NAME, this._onChange.bind(this), true);
      };

      TextSelectionObserver.prototype._getSelection = function(event) {
        var selection;
        selection = this.element.getSelection();
        return {
          anchorNode: selection.anchorNode,
          anchorOffset: selection.anchorOffset,
          focusNode: selection.focusNode,
          focusOffset: selection.focusOffset,
          timestamp: (event != null ? event.timeStamp : void 0) || (new Date().getTime())
        };
      };

      TextSelectionObserver.prototype._onChange = _.throttle((function(event) {
        return this.trigger('select', [this._getSelection(event)]);
      }), 500);

      return TextSelectionObserver;

    })(EventEmitter);
  });

}).call(this);
