(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lodash', 'eventEmitter'], function(_, EventEmitter) {
    var MouseObserver, _ref;
    return MouseObserver = (function(_super) {
      __extends(MouseObserver, _super);

      function MouseObserver() {
        _ref = MouseObserver.__super__.constructor.apply(this, arguments);
        return _ref;
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
        return this._listener = this.element.addEventListener('mousemove', this._onChange.bind(this), false);
      };

      MouseObserver.prototype.disconnect = function() {
        return this.element.removeEventListener('mousemove', this._onChange.bind(this), false);
      };

      MouseObserver.prototype._onChange = _.throttle((function(event) {
        var x, y;
        x = event.clientX;
        y = event.clientY;
        return this.trigger('mouse_moved', [
          {
            x: x,
            y: y,
            timestamp: event.timeStamp
          }
        ]);
      }), 100);

      return MouseObserver;

    })(EventEmitter);
  });

}).call(this);
