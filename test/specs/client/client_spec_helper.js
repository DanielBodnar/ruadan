var fixtures = require('js-fixtures');
fixtures.path = 'base/test/fixtures/client';
chai.use(require('sinon-chai'))
chai.showDiff = true;
chai.includeStack = true;