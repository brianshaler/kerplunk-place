Promise = require 'when'
levelWriteStream = require 'level-ws'

cityToKeyedRecords = require './transform/cityToKeyedRecords'

module.exports = (cityStream, targetDB) ->
  Promise.promise (resolve, reject) ->
    #levelStream = targetDB.createWriteStream()
    levelStream = levelWriteStream(targetDB).createWriteStream()
    itemCount = 0
    cityStream
      .on 'data', (item) -> itemCount++
      .pipe cityToKeyedRecords()
      .pipe levelStream
      .on 'error', (err) ->
        reject err
      .on 'close', -> # close instead of end.. grr
        resolve itemCount
