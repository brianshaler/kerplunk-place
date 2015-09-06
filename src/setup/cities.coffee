path = require 'path'
Promise = require 'when'
es = require 'event-stream'

streamCityRecords = require './streamCityRecords'
csvObjectToCity = require './transform/csvObjectToCity'
cityStreamToLevel = require './cityStreamToLevel'
cityStreamToMongo = require './cityStreamToMongo'

mongoCount = (Model, where = {}) ->
  deferred = Promise.defer()
  Model.count where, (err, count) ->
    return deferred.reject err if err
    deferred.resolve count
  deferred.promise

levelCount = (db, key = 'cities', start = 'cityid:', end = 'cityid;') ->
  deferred = Promise.defer()

  db.get key, (err, record) ->
    if record
      return deferred.resolve record.count
    count = 0
    opt =
      start: start
      end: end
    db.createKeyStream opt
    .on 'data', -> count++
    .on 'error', (err) -> deferred.reject err
    .on 'end', ->
      db.put key, {count: count}
      deferred.resolve count

  deferred.promise

module.exports = (db, Place) ->
  (countryPlaces) ->
    console.log 'setting up cities'
    cityWhere =
      'data.cityId':
        '$exists': true
    return Promise.all [
      mongoCount Place, cityWhere
      levelCount db
    ]
    .then (counts) ->
      console.log 'counts', counts
      if counts[0] >= 8782 and counts[1] >= 138398
        return counts

      #return console.log 'ok..'

      cityStream = streamCityRecords()
        .pipe es.map csvObjectToCity countryPlaces
      #cityStream = streamCityRecords path.resolve __dirname, '../../test/fixtures/citiessample.txt'

      cityStream.on 'end', ->
        console.log 'cityStream ended'

      Promise.all [
        cityStreamToLevel cityStream, db
        cityStreamToMongo cityStream, Place, 'guid', 50000
      ]
      .then (results) ->
        db.put 'cities', {count: results[0]}
        if results[1]?.inserted and results[1].existed
          results[1] = results[1].inserted + results[1].existed
        results
