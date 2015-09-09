Promise = require 'when'
es = require 'event-stream'

populationFilter = require './populationFilter'
mongoFindOrCreate = require './mongoFindOrCreate'
cityToPlace = require './transform/cityToPlace'

module.exports = (cityStream, Model, keyProp, minPopulation = 50000) ->
  Promise.promise (resolve, reject) ->
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
        reject err
      .on 'end', ->
        resolve
          preFilter: preFilter
          postFilter: postFilter
          inserted: inserted
          existed: existed
