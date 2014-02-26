GLOBAL.APP_ROOT = __dirname;
GLOBAL.require_app = function(path) {
  var args = Array.prototype.slice.call(arguments);
  return require.apply(null, [GLOBAL.APP_ROOT + "/" + path].concat(args.slice(1)));
}
require("coffee-script/register");
require("./app/app.coffee");
