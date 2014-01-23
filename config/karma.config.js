// Karma configuration
// Generated on Sat May 25 2013 01:17:48 GMT+0300 (IDT)


// base path, that will be used to resolve files and exclude
basePath = '';


// list of files / patterns to load in the browser
files = [
  JASMINE,
  JASMINE_ADAPTER,
  REQUIRE,
  REQUIRE_ADAPTER,
  // simple patterns to load the needed testfiles

  {pattern: '../node_modules/chai/chai.js', included: false},
  {pattern: '../test/support/**/*.js', watched: true, included: true, served: true},
  {pattern: '../test/fixtures/**/*.html', watched: true, included: false, served: true},

  {pattern: '../lib/**/*.js', included: false},
  {pattern: '../lib/**/*.coffee', included: false},
  {pattern: '../app/**/*.js', included: false},

  {pattern: '../app/**/*.coffee', included: false},
  {pattern: '../test/**/*_spec.js', included: false},
  {pattern: '../test/**/*_spec.coffee', included: false},

  '../test/test-main.js'
];

preprocessors = {
  '../**/*.coffee': 'coffee'
//  '**/*.html': 'html2js'
};

// list of files to exclude
exclude = [

];

proxies = {
  '/': 'http://localhost:3000/'
};

// test results reporter to use
// possible values: 'dots', 'progress', 'junit'
reporters = ['progress', 'growl', 'dots'];


// web server port
port = 3019;


// cli runner port
runnerPort = 9200;


// enable / disable colors in the output (reporters and logs)
colors = true;


// level of logging
// possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
logLevel = LOG_INFO;

reportSlowerThan = 1000;
// enable / disable watching file and executing tests whenever any file changes
autoWatch = true;


// Start these browsers, currently available:
// - Chrome
// - ChromeCanary
// - Firefox
// - Opera
// - Safari (only Mac)
// - PhantomJS
// - IE (only Windows)
browsers = ['PhantomJS'];


// If browser does not capture in given timeout [ms], kill it
captureTimeout = 60000;


// Continuous Integration mode
// if true, it capture browsers, run tests and exit
singleRun = false;
