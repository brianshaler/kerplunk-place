Promise = require 'when'
es = require 'event-stream'

populationFilter = require './populationFilter'
mongoFindOrCreate = require './mongoFindOrCreate'
cityToPlace = require './transform/cityToPlace'

module.exports = (cityStream, Model, keyProp, minPopulation = 50000) ->
  deferred = Promise.defer()
  preFilter = 0
  postFilter = 0
  inserted = 0
  existed = 0
  cityStream
    .on 'data', -> preFilter++
    .pipe es.map populationFilter minPopulation
    .on 'data', -> postFilter++
    .pipe es.map cityToPlace
    .pipe es.map mongoFindOrCreate Model, keyProp
    .on 'data', (result) ->
      if result == 'inserted'
        inserted++
      else if result == 'existed'
        existed++
    .on 'error', (err) ->
      deferred.reject err
    .on 'end', ->
      deferred.resolve
        preFilter: preFilter
        postFilter: postFilter
        inserted: inserted
        existed: existed
  deferred.promise
