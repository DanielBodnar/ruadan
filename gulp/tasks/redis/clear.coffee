gulp  = require('gulp')
store = require('./lib/redis_event_store.coffee')

gulp.task('redis:clear', -> store.getClient().flushdb())