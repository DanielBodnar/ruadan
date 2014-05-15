require('coffee-script/register');
require('./config/application.coffee');
var spawn = require('child_process').spawn;
var Session = require("./app/models/session.coffee");


console.log("::Getting all sessions::");
Session.all().then(function(sessions) {
    if (sessions.length === 0) {
      throw 'no sessions';
    } else {
      var sessionsIds = sessions.map( function(session) {
        return session.attributes.id;
      });

      var lastSession = sessionsIds[sessionsIds.length-1];

      console.log("::executing: '" + 'phantomjs --load-images=true phantom.js ' + lastSession + "'::");

      var phantom = spawn('phantomjs',['--load-images=true', 'phantom.js', lastSession]);

      phantom.stdout.setEncoding('utf8');
      phantom.stdout.on('data', function (data) {
        console.log("data", data);
      });

      phantom.stderr.setEncoding('utf8');
      phantom.stderr.on('data', function (data) {
        console.log('stderr: ' + data);
      });
    }
});
