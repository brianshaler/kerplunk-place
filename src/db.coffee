path = require 'path'
levelup = require 'levelup'

baseDir = process.env.BASE_DIR ? path.resolve __dirname, '../../..'
defaultPath = path.join baseDir, 'cache'
defaultName = 'db'

dbopt =
  valueEncoding: 'json'

module.exports = (dbPath = defaultPath, name = defaultName) ->
  fullPath = path.join dbPath, name
  levelup fullPath, dbopt
