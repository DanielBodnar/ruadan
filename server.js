require('coffee-script/register');

var http = require('http');
var app = require('./config/application.coffee');


http.createServer(app).listen(app.get('port'), function() {
  console.log("Express server listening on port %s in %s mode", app.get('port'), app.settings.env);
});
