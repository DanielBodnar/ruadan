(function() {
  define([], function() {
    var ID_PROP, NodeMap, ensureId, getId, hasId, setId;
    ID_PROP = '__mutation_summary_node_map_id__';
    NodeMap = (function() {
      function NodeMap() {
        this.currId = 0;
        this._nodeMap = {};
      }

      NodeMap.prototype.set = function(node, value) {
        var id;
        id = ensureId(node, this.getNextId());
        this._nodeMap[getId(node)] = {
          k: node,
          v: value
        };
        return id;
      };

      NodeMap.prototype.get = function(node, defaultValue) {
        var byId, result;
        if (defaultValue == null) {
          defaultValue = null;
        }
        result = defaultValue;
        if (hasId(node)) {
          byId = this._nodeMap[getId(node)];
          if (byId) {
            result = byId.v;
          }
        }
        return result;
      };

      NodeMap.prototype.has = function(node) {
        return hasId(node) && getId(node) in this._nodeMap;
      };

      NodeMap.prototype["delete"] = function(node) {
        if (hasId(node)) {
          return delete this._nodeMap[getId(node)];
        }
      };

      NodeMap.prototype.getNextId = function() {
        return this.currId++;
      };

      return NodeMap;

    })();
    ensureId = function(node, nextId) {
      if (!hasId(node)) {
        setId(node, nextId);
      }
      return getId(node);
    };
    hasId = function(node) {
      return getId(node) != null;
    };
    getId = function(node) {
      return node[ID_PROP];
    };
    setId = function(node, id) {
      return node[ID_PROP] = id;
    };
    return NodeMap;
  });

}).call(this);
