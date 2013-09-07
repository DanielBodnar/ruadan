(function() {
  define(['lodash'], function(_) {
    var Observer;
    return Observer = (function() {
      function Observer() {
        var MutationObserver,
          _this = this;
        MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
        this.observer = new MutationObserver(function(mutations) {
          return _this._onChange(mutations);
        });
      }

      Observer.prototype.observe = function(el, options) {
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

      Observer.prototype.disconnect = function() {
        return this.observer.disconnect();
      };

      Observer.prototype._onChange = function(mutations) {
        return this.trigger('change', [mutations]);
      };

      return Observer;

    })();
  });

}).call(this);
