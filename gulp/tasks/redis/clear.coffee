gulp  = require('gulp')
Redis = require('redis')

gulp.task('redis_clear', -> Redis.createClient().flushdb())
