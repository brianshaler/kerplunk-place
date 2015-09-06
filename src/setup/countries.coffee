_ = require 'lodash'
Promise = require 'when'
countries = require 'world-countries'

countryCodeToPlace = require './transform/countryCodeToPlace'

countryCodes = _ countries
  .map (country) ->
    [country.cca2, country.cca3]
  .flatten()
  .value()

getCountries = (Place) ->
  deferred = Promise.defer()
  Place.find
    'data.countryCode':
      '$exists': true
    'data.cityId':
      '$exists': false
  , (err, countryPlaces) ->
    return deferred.reject err if err
    deferred.resolve countryPlaces
  deferred.promise

module.exports = (Place, expectedCount = -1) ->
  getCountries Place
  .then (countryPlaces) ->
    if countryPlaces.length == expectedCount
      return countryPlaces

    placesByCode = {}
    for place in countryPlaces
      placesByCode[place.data.countryCode] = place
    reduce = (memo, countryCode) ->
      memo[if placesByCode[countryCode] then 0 else 1].push countryCode
      memo
    [loaded, toLoad] = _.reduce countryCodes, reduce, [[],[]]
    console.log "[loaded:#{loaded}, toLoad:#{toLoad}]"

    if toLoad.length == 0
      return countryPlaces

    docs = _.compact _.map toLoad, countryCodeToPlace

    if docs.length == 0
      return countryPlaces

    deferred = Promise.defer()
    Place.collection.insert docs, {}, (err) ->
      console.log err if err
      return deferred.reject err if err
      deferred.resolve()

    deferred.promise
    .then ->
      getCountries Place
