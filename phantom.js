var page = require('webpage').create();
var args = require('system').args;

var sessionId = args[1];

page.open('http://127.0.0.1:3100/phantom/'+sessionId, function (status) {

  if (status !== 'success') {
    throw 'Unable to access network';
  } else {
    page.onCallback = function(data) {
      console.log('CALLBACK: ' + JSON.stringify(data));
      phantom.exit();
    };
    page.onConsoleMessage = function(msg, lineNum, sourceId) {
      console.log('CONSOLE: ' + msg + ' (from line #' + lineNum + ' in "' + sourceId + '")');
    };
    page.onError = function(msg, trace) {
      var msgStack = ['ERROR: ' + msg];
      if (trace && trace.length) {
        msgStack.push('TRACE:');
        trace.forEach(function(t) {
          msgStack.push(' -> ' + t.file + ': ' + t.line + (t.function ? ' (in function "' + t.function + '")' : ''));
        });
      }
      console.error(msgStack.join('\n'));
    };

    var ua = page.evaluate(function () {

      window.bootstrapReplayer.getEvents(""+sessionId, window.document, function(events, document){
        console.log("events: " + events);
      });
    });
    console.log("ua: " + ua);
  }
//  page.render('github.png');
//  phantom.exit();
});