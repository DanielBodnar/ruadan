var system = require('system');
if (system.args.length < 2) {
  console.log('Please provide an address');
  phantom.exit(1);
}

var page = require('webpage').create();

page.open(system.args[1], function() {
  page.evaluate(function() {
    if (document.body.bgColor == undefined || document.body.bgColor == 'none' || document.body.bgColor == '') {
      document.body.bgColor = 'white';
    }
  });
  setInterval(function() {
    var running = page.evaluate(function() {
      return window.ruadanRunning;
    });
    var viewport = page.evaluate(function() {
      if (window.ruadanViewport != undefined) {
        return window.ruadanViewport;
      } else {
        return null;
      }
    });
    if (params) {
      page.viewportSize = { width: viewport.width, height: viewport.height };
      page.clipRect = viewport;
    }
    page.render("/dev/stdout", { format: "png" });
    if (!running) {
      phantom.exit();
    }
  }, 200);
});
