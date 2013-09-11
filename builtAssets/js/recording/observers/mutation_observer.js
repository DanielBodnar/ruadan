(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lodash', 'eventEmitter'], function(_, EventEmitter) {
    var MutationObserver;
    return MutationObserver = (function(_super) {
      __extends(MutationObserver, _super);

      function MutationObserver() {
        var _this = this;
        MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
        this.observer = new MutationObserver(function(mutations) {
          return _this._onChange(mutations);
        });
      }

      MutationObserver.prototype.observe = function(el, options) {
        var defaultOptions;
        if (options == null) {
          options = {};
        }
        defaultOptions = {
          childList: true,
          attributes: true,
          characterData: true,
          subtree: true,
          attributeOldValue: true,
          characterDataOldValue: true,
          cssProperties: true,
          cssPropertyOldValue: true,
          attributeFilter: []
        };
        return this.observer.observe(el, _.extend(defaultOptions, options));
      };

      MutationObserver.prototype.disconnect = function() {
        return this.observer.disconnect();
      };

      MutationObserver.prototype._onChange = function(mutations) {
        return this.trigger('change', [mutations]);
      };

      return MutationObserver;

    })(EventEmitter);
  });

}).call(this);
