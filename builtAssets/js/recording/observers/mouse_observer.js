(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lodash', 'eventEmitter'], function(_, EventEmitter) {
    var MouseObserver;
    return MouseObserver = (function(_super) {
      __extends(MouseObserver, _super);

      function MouseObserver() {
        var _this = this;
        this._listenerFunc = function(e) {
          return _this._onChange(e);
        };
      }

      MouseObserver.prototype.initialize = function(element) {
        this.element = element;
        return this.trigger("initialize", [
          {
            x: 0,
            y: 0,
            timestamp: new Date().getTime()
          }
        ]);
      };

      MouseObserver.prototype.observe = function() {
        return this._listener = this.element.addEventListener('mousemove', this._listenerFunc, false);
      };

      MouseObserver.prototype.disconnect = function() {
        return this.element.removeEventListener('mousemove', this._listenerFunc, false);
      };

      MouseObserver.prototype._onChange = function(event) {
        var x, y;
        x = event.pageX;
        y = event.pageY;
        return this.trigger('mouseMoved', [
          {
            x: x,
            y: y,
            timestamp: event.timeStamp
          }
        ]);
      };

      return MouseObserver;

    })(EventEmitter);
  });

}).call(this);
