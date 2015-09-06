Promise = require 'when'
levelWriteStream = require 'level-ws'

cityToKeyedRecords = require './transform/cityToKeyedRecords'

module.exports = (cityStream, targetDB) ->
  deferred = Promise.defer()
  #levelStream = targetDB.createWriteStream()
  levelStream = levelWriteStream(targetDB).createWriteStream()
  itemCount = 0
  cityStream
    .on 'data', (item) -> itemCount++
    .pipe cityToKeyedRecords()
    .pipe levelStream
    .on 'error', (err) ->
      deferred.reject err
    .on 'close', -> # close instead of end.. grr
      deferred.resolve itemCount
  deferred.promise
