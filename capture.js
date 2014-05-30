require('coffee-script/register');
require('./config/application.coffee');
var spawn = require('child_process').spawn;
var Session = require("./app/models/session.coffee");

function startPhantom(lastSession, lastEventTimestamp, width, height) {
  var lastSessionId = lastSession.attributes.id;
  console.log("::executing: 'phantomjs --load-images=true phantom.js " +
    lastSessionId + ":" +
    lastEventTimestamp + "'::");

  var params = ["--load-images=true", "phantom.js", lastSessionId, lastEventTimestamp, width, height];
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

Session.all().then(function (sessions) {
  if (sessions.length === 0) {
    throw "no sessions";
  } else {

    var lastSession = sessions[sessions.length - 1];

    lastSession.getEvents().then(function (events) {
      var width = 0;
      var height = 0;
      events.forEach(function (event) {
        switch(event.attributes.action){
          case "viewport":
            console.dir(event);
            break;
          case "newPage":
            var data = events[0].attributes.data.viewport.data;
            var tempWidth = data.left + data.width;
            var tempHeight = data.top + data.height;

            if(tempWidth>width){
              width = tempWidth;
            }

            if(tempHeight>height) {
              height = tempHeight;
            }
            break;
        }
      });
      var firstEventTimestamp = events[0].attributes.timestamp;
      var lastEvent = events[events.length - 1];
      var lastEventTimestamp = lastEvent.attributes.timestamp - firstEventTimestamp;

      startPhantom(lastSession, lastEventTimestamp, width, height);
    });
  }
});
