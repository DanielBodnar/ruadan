(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lodash', 'eventEmitter'], function(_, EventEmitter) {
    var ScrollObserver, _ref;
    return ScrollObserver = (function(_super) {
      __extends(ScrollObserver, _super);

      function ScrollObserver() {
        _ref = ScrollObserver.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ScrollObserver.prototype.initialize = function(element) {
        this.element = element;
        return this.trigger("initialize", [
          {
            x: this.element.scrollX,
            y: this.element.scrollY,
            timestamp: new Date().getTime()
          }
        ]);
      };

      ScrollObserver.prototype.observe = function() {
        return this._listener = this.element.addEventListener('scroll', this._onChange.bind(this), false);
      };

      ScrollObserver.prototype.disconnect = function() {
        return this.element.removeEventListener('scroll', this._onChange.bind(this), false);
      };

      ScrollObserver.prototype._onChange = function(event) {
        var x, y;
        x = this.element.scrollX;
        y = this.element.scrollY;
        return this.trigger('scroll', [
          {
            x: x,
            y: y,
            timestamp: event.timeStamp
          }
        ]);
      };

      return ScrollObserver;

    })(EventEmitter);
  });

}).call(this);
