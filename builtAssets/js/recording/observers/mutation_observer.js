(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lodash', 'eventEmitter', 'recording/serializer'], function(_, EventEmitter, Serializer) {
    var MutationObserver;
    return MutationObserver = (function(_super) {
      __extends(MutationObserver, _super);

      function MutationObserver() {
        this.serializer = new Serializer();
        MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
        this.observer = new MutationObserver(this._onChange.bind(this));
      }

      MutationObserver.prototype.initialize = function(element) {
        var currentState, eventData;
        this.element = element;
        currentState = this.serializer.serialize(this.element, true);
        eventData = {
          nodes: currentState,
          timestamp: new Date().getTime()
        };
        return this.trigger("initialize", [eventData]);
      };

      MutationObserver.prototype.observe = function(options) {
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
        return this.observer.observe(this.element, _.extend(defaultOptions, options));
      };

      MutationObserver.prototype.disconnect = function() {
        return this.observer.disconnect();
      };

      MutationObserver.prototype._onChange = function(mutations) {
        var result;
        result = _(mutations).map(this._handleMutation.bind(this)).flatten().value();
        return this.trigger('change', [result]);
      };

      MutationObserver.prototype._handleMutation = function(mutation) {
        var result;
        result = {};
        if (this._hasAddedNodes(mutation)) {
          result.addedNodes = this._serializeNodes(mutation.addedNodes);
        }
        if (this._hasRemovedNodes(mutation)) {
          result.removedNodes = this._serializeNodes(mutation.removedNodes);
        }
        if (mutation.nextSibling) {
          result.nextSiblingId = this.serializer.knownNodesMap.get(mutation.nextSibling).id;
        }
        if (mutation.previousSibling) {
          result.previousSiblingId = this.serializer.knownNodesMap.get(mutation.previousSibling).id;
        }
        result.type = mutation.type;
        result.oldValue = mutation.oldValue;
        result.attributeName = mutation.attributeName;
        result.targetNodeId = this.serializer.knownNodesMap.get(mutation.target).id;
        result.timestamp = new Date().getTime();
        return result;
      };

      MutationObserver.prototype._hasAddedNodes = function(mutation) {
        var _ref;
        return ((_ref = mutation.addedNodes) != null ? _ref.length : void 0) > 0;
      };

      MutationObserver.prototype._hasRemovedNodes = function(mutation) {
        var _ref;
        return ((_ref = mutation.removedNodes) != null ? _ref.length : void 0) > 0;
      };

      MutationObserver.prototype._serializeNodes = function(nodes) {
        var _this = this;
        return _.map(nodes, function(node) {
          return _this.serializer.serialize(node, true);
        });
      };

      return MutationObserver;

    })(EventEmitter);
  });

}).call(this);
