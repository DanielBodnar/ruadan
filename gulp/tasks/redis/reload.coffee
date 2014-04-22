gulp  = require('gulp')

redisServer = null;
gulp.task('redis:test:reload', ->
  spawn = require('child_process').spawn
  redisServer.kill('SIGHUP') if redisServer

  redisServer = spawn('redis-server', ['redis_test.conf'])
)
