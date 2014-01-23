var tests = Object.keys(window.__karma__.files).filter(function (file) {
  return /_spec\.coffee-compiled\.js$/.test(file);
});

f = jasmine.getFixtures();
f.fixturesPath = '/test/fixtures';

requirejs.config({
  // Karma serves files from '/base'
  baseUrl: 'js/',

  // ask Require.js to load these files (all our tests)
  deps: tests,
  // start test run, once Require.js is done
  callback: window.__karma__.start
});
