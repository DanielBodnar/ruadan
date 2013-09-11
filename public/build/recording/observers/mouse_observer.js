(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lodash', 'eventEmitter'], function(_, EventEmitter) {
    var MutationObserver;
    return MutationObserver = (function(_super) {
      __extends(MutationObserver, _super);

      function MutationObserver() {}

      MutationObserver.prototype.observe = function(el, options) {
        var _this = this;
        this.el = el;
        if (options == null) {
          options = {};
        }
        this._listenerFunc = function(e) {
          return _this._onChange(e);
        };
        return this._listener = this.el.addEventListener('mousemove', this._listenerFunc, false);
      };

      MutationObserver.prototype.disconnect = function() {
        return this.el.removeEventListener('mousemove', this._listenerFunc, false);
      };

      MutationObserver.prototype._onChange = function(event) {
        var x, y;
        x = event.pageX;
        y = event.pageY;
        return this.trigger('change', [
          {
            x: x,
            y: y,
            timestamp: event.timeStamp
          }
        ]);
      };

      return MutationObserver;

    })(EventEmitter);
  });

}).call(this);
