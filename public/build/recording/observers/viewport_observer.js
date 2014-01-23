(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['eventEmitter'], function(EventEmitter) {
    var ViewportObserver;
    return ViewportObserver = (function(_super) {
      __extends(ViewportObserver, _super);

      function ViewportObserver() {
        var _this = this;
        this._listenerFunc = function(e) {
          return _this._onChange(e);
        };
      }

      ViewportObserver.prototype.initialize = function(element) {
        this.element = element;
        return this.trigger("initialize", [
          {
            width: this.element.clientWidth,
            height: this.element.clientHeight,
            timestamp: new Date().getTime()
          }
        ]);
      };

      ViewportObserver.prototype.observe = function() {};

      ViewportObserver.prototype.disconnect = function() {};

      ViewportObserver.prototype._onChange = function(event) {};

      return ViewportObserver;

    })(EventEmitter);
  });

}).call(this);
