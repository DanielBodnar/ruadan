# A database for the stubs to work with
DB =
  sessions: ['abcd','efgh','ijkl']
  'session:abcd': [{score: 5000, data: "asdfasdfasdf"}, {score: 13200, data: "2349876"}]
  'session:efgh': [{score: 2000, data: "asdfasdfasdf"}]
  'session:ijkl': [{score: 1000, data: "asdfasdfasdf"}, {score: 21100, data: "asdlkjh6"}]
  'session:abcd:domInited': 'true'

# an event to insert to the DB
MOCK_EVENT =
  attributes:
    action: 'moshe'
    timestamp: 50
    eventData:
      kuku: 'riku'


module.exports.DB = DB
module.exports.MOCK_EVENT = MOCK_EVENT
