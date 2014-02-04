(function() {
  define(['lodash'], function(_) {
    var Deserializer;
    return Deserializer = (function() {
      function Deserializer(document, root, idMap) {
        this.document = document;
        this.root = root != null ? root : null;
        this.idMap = idMap != null ? idMap : {};
        this.root = this.document.implementation.createHTMLDocument();
      }

      Deserializer.prototype.deleteNode = function(nodeData) {
        return delete this.idMap[nodeData.id];
      };

      Deserializer.prototype.deserialize = function(nodeData, parent) {
        var child, href, node, _i, _len, _ref, _ref1;
        if (parent == null) {
          parent = this.root;
        }
        if (nodeData == null) {
          return null;
        }
        node = this.idMap[nodeData.id];
        if (node != null) {
          return node;
        }
        switch ("" + nodeData.nodeType) {
          case "" + Node.COMMENT_NODE:
            node = this.root.createComment(nodeData.textContent);
            break;
          case "" + Node.TEXT_NODE:
            node = this.root.createTextNode(nodeData.textContent);
            break;
          case "" + Node.DOCUMENT_TYPE_NODE:
            node = this.root.implementation.createDocumentType(nodeData.name, nodeData.publicId, nodeData.systemId);
            break;
          case "" + Node.ELEMENT_NODE:
            switch (nodeData.tagName) {
              case 'HTML':
                node = this.root.getElementsByTagName("html")[0];
                break;
              case 'HEAD':
                node = this.root.getElementsByTagName("head")[0];
                break;
              case 'BODY':
                node = this.root.getElementsByTagName("body")[0];
                break;
              case 'LINK':
                if (((_ref = nodeData.attributes["rel"]) != null ? _ref.toLowerCase() : void 0) !== "stylesheet") {
                  break;
                }
                node = this._createElement("style");
                href = nodeData.attributes["href"];
                nodeData.attributes["xhref"] = href;
                delete nodeData.attributes["href"];
                node.innerHTML = nodeData.styleText;
                break;
              case 'IFRAME':
                node = this.root.createComment('iframe');
                break;
            }
            if (!node) {
              node = this._createElement(nodeData.tagName);
            }
            if (node.nodeType !== Node.COMMENT_NODE) {
              this._addAttributes(node, nodeData.attributes);
            }
        }
        if (!(("" + nodeData.nodeType) === ("" + Node.ELEMENT_NODE) && node.nodeType === Node.COMMENT_NODE)) {
          this._addStyle(node, nodeData.styles);
        }
        if (!node) {
          throw "ouch";
        }
        this.idMap[nodeData.id] = node;
        switch (nodeData.tagName) {
          case 'HTML':
          case 'HEAD':
          case 'BODY':
            break;
          default:
            if (parent && ("" + parent.nodeType) !== ("" + Node.COMMENT_NODE)) {
              node = parent.appendChild(node);
            }
        }
        if (nodeData.childNodes != null) {
          _ref1 = nodeData.childNodes;
          for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
            child = _ref1[_i];
            this.deserialize(child, node);
          }
        }
        return node;
      };

      Deserializer.prototype._createElement = function(tagName) {
        var node;
        switch (tagName) {
          case 'SCRIPT':
            node = this.root.createElement('NO-SCRIPT');
            node.style.display = 'none';
            break;
            break;
          default:
            node = this.root.createElement(tagName);
            break;
        }
        return node;
      };

      Deserializer.prototype._addAttributes = function(node, attributes) {
        _.each(attributes, function(value, key) {
          if (!_.isEmpty(value)) {
            return node.setAttribute(key, value);
          }
        });
        return node;
      };

      Deserializer.prototype._addStyle = function(node, styles) {
        return _.each(styles, function(value, key) {
          return node.style[value[0]] = value[1];
        });
      };

      return Deserializer;

    })();
  });

}).call(this);
