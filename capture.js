require('coffee-script/register');
require('./config/application.coffee');
var spawn = require('child_process').spawn;
var Session = require("./app/models/session.coffee");

function startPhantom(lastSession, lastEventTimestamp){
  var lastSessionId = lastSession.attributes.id;
  console.log("::executing: 'phantomjs --load-images=true phantom.js " +
      lastSessionId + ":"+
      lastEventTimestamp + "'::");

  var params = ["--load-images=true", "phantom.js", lastSessionId, lastEventTimestamp];
  var phantom = spawn("phantomjs", params);

  phantom.stdout.setEncoding("utf8");
  phantom.stdout.on("data", function (data) {
    console.log(data);
  });

  phantom.stderr.setEncoding("utf8");
  phantom.stderr.on("data", function (data) {
    console.log("stderr: " + data);
  });
}

console.log("::Getting all sessions::");

Session.all().then(function(sessions) {
    if (sessions.length === 0) {
      throw "no sessions";
    } else {

      var lastSession = sessions[sessions.length-1];

      lastSession.getEvents().then( function(events) {

        var firstEventTimestamp = events[0].attributes.timestamp;
        var lastEvent = events[events.length-1];
        var lastEventTimestamp = lastEvent.attributes.timestamp - firstEventTimestamp;

        startPhantom(lastSession, lastEventTimestamp);
      });
    }
});
