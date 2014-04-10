process.env.NODE_ENV = "test";

require('aliasify').configure({
  aliases: {
    "window": "./mocks/window.coffee"
  },
  configDir: __dirname,
  verbose: true,
  appliesTo: { includeExtensions: [".js", ".coffee"] }
});

chai = require('chai');
sinon = require('sinon');
path = require('path');
chai = require('chai');
require('mocha-as-promised')();
chai.use(require('chai-as-promised'));
chai.use(require('sinon-chai'));


GLOBAL.rek = function (file, forceReload) {
  var forceRecord = forceReload || false;
  var modulePath = path.resolve(path.join(__dirname, "/../../", file));
  if (forceReload) {
    delete require.cache[modulePath];
  }
  return require(modulePath);
};

process.on('uncaughtException', console.log.bind(console));

GLOBAL.assert = require('assert');
GLOBAL._ = require('lodash');
GLOBAL.expect = chai.expect;
GLOBAL.sinon = sinon;
