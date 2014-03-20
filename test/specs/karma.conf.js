module.exports = function (config) {
  return config.set({
    basePath: '../..',
    autoWatch: true,
    autoWatchBatchDelay: 50,
    browsers: ['Chrome'],
    frameworks: ['mocha', 'browserify', 'chai', 'sinon'],
    reporters: ['progress', 'osx'],
    preprocessors: {
      '**/*.coffee': ['coffee'],
      'test/specs/client/**/*': ['browserify'],
      'client/**/*': ['browserify']
    },
    browserify: {
      extensions: ['.coffee'],
      transform: ['coffeeify'],
      watch: true,
      debug: true
    },
    coffeePreprocessor: {
      options: {
        sourceMap: true
      }
    }
  });
};
