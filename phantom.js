var page = require('webpage').create();
var args = require('system').args;

var sessionId = args[1];
var lastEventTimestamp = args[2];
var currentTimestamp = 0;
var timeout = null;

function didRecordAll(){
  return currentTimestamp > lastEventTimestamp;
}

function runNextTimestamp() {
  return window.runNextTimestamp();
}

function takeSnapshotNow() {
  if(timeout) { clearTimeout(timeout); }
  var res = page.evaluate(runNextTimestamp);
  currentTimestamp = res.timestamp;
  if (!res.hasEvents) {
    console.log("no events");
    setTimeout(function(){
      takeSnapshotNow();
    },0);
  } else {
    page.render('movie_export/' + currentTimestamp + '.png')
    timeout = setTimeout(function () {
      takeSnapshot();
    }, 100);
  }
  console.log(currentTimestamp + " - " + lastEventTimestamp);
}


function takeSnapshot() {
  takeSnapshotNow();
  if (!didRecordAll()) {
    timeout = setTimeout(function () {
      takeSnapshot();
    }, 10000);
  } else if (didRecordAll()) {
    console.log("DONE!");
    phantom.exit();
  }
}

page.onCallback = function (data) {
  console.log("got callback ", data);
  switch (data) {
    case "simulatorCreated":
      takeSnapshot();
      break;
    default:
      throw JSON.stringify(data);

  }
};

page.onConsoleMessage = function (msg, lineNum, sourceId) {
  console.log('CONSOLE: ' + msg + ' (from line #' + lineNum + ' in "' + sourceId + '")');
};

page.onResourceRequested = function(requestData, networkRequest) {
  console.log('Request (#' + requestData.id + '): ',
      JSON.stringify(requestData),
      JSON.stringify(networkRequest));
};

page.onError = function (msg, trace) {
  var msgStack = ['ERROR: ' + msg];
  if (trace && trace.length) {
    msgStack.push('TRACE:');
    trace.forEach(function (t) {
      var funcName = (t.function ? ' (in function "' + t.function + '")' : '');
      msgStack.push(' -> ' + t.file + ': ' + t.line + funcName);
    });
  }
  console.error(msgStack.join('\n'));
};

page.open('http://rlocal.giftsproject.com/phantom/' + sessionId, function (status) {
  console.log(status);
  if (status !== 'success') {
    throw 'Unable to access network';
  }
});