nconf = require('nconf')
_ = require('lodash')
path = require('path')
fs = require('fs')


detectEnvironment = -> process.env.NODE_ENV || "development"

getLoadPaths = (type, configDir) ->
  paths = {}

  # 'eg config/settings.defaults.json'
  paths.defaults = path.join(configDir, "#{type}.defaults.json")


  # 'eg' ./settings.json
  paths.overrides = path.join(configDir, "#{type}.json")
  loadPaths = [paths.defaults]
  loadPaths.push paths.overrides  if fs.existsSync(paths.overrides)
  loadPaths


getConfiguration = (type, currentEnvironment) ->
  config = nconf.stores[type]
  defaults = config.get("defaults")
  environmentOverrides = config.get(currentEnvironment)
  _.extend defaults, environmentOverrides
  defaults

createConfiguration = (type, configDir) ->
  nconf.add type,
    type: "memory"
    loadFrom: getLoadPaths(type, configDir)

  process.env.NODE_ENV = detectEnvironment()
  getConfiguration type, process.env.NODE_ENV


createConfigurationFromDir = (dir)->
  result = {}
  fs.readdirSync(dir)
    .map((file)-> path.join(dir, file))
    .filter((file) -> fs.statSync(file).isFile())
    .forEach((file)->
      nakedFile = path.basename(file, ".defaults.json")
      result[nakedFile] = createConfiguration(nakedFile, dir)
    )
  result

# This is an environment aware configuration reader, please see:
# https://gist.github.com/timoxley/2071419
# for more info
exports.createConfiguration = createConfiguration
exports.createConfigurationFromDir = createConfigurationFromDir