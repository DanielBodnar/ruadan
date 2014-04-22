autoConf = require('../lib/auto_conf.coffee')
fs = require("fs")
path = require("path")

dir = './config/files'
config = autoConf.createConfigurationFromDir(dir)

# some overrides to support various deployers
config.app.port = process.env.PORT || config.app.port
config.app.port = process.argv[process.argv.indexOf('-p') + 1] if process.argv.indexOf('-p') >= 0
module.exports = config
