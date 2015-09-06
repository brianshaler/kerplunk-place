Promise = require 'when'
es = require 'event-stream'

PlaceSchema = require './models/Place'

DB = require './db'
Setup = require './setup'

PlaceTransforms = require './setup/transform'

db = null

module.exports = (System) ->
  Place = System.registerModel 'Place', PlaceSchema

  db = DB null, 'levelPlaces' unless db

  #setupCities = Setup.cities System, db
  #setupCountries = Setup.countries System

  saveLevelCityToMongo = (cityId, next) ->
    Place.findOne
      guid: "city-#{cityId}"
    , (err, place) ->
      return next err if err
      return next null, place if place
      db.get "cityid:#{cityId}", (err, levelCity) ->
        return next err if err
        return next new Error 'not found' if !levelCity
        city = PlaceTransforms.levelToCity levelCity
        PlaceTransforms.cityToPlace city, (err, placeData) ->
          place = new Place placeData
          place.save (err) ->
            next err, place

  saveCityById = (req, res, next) ->
    saveLevelCityToMongo req.params.cityId, (err, city) ->
      return next err if err
      res.send city

  getByCityId = (req, res, next) ->
    cityId = req.params.cityId
    db.get "cityid:#{cityId}", (err, city) ->
      return next() unless city
      obj =
        name: city[0]
        asciiName: city[0]
        region: city[1]
        country: city[2]
        location: [city[3], city[4]]
        population: city[5]
        cityId: city[6]
        timezone: city[7]
      res.send obj

  getPlaceByCityId = (req, res, next) ->
    Place.findOne
      guid: req.params.guid
    , (err, place) ->
      return next err if err
      return next() unless place
      res.send place

  routes:
    admin:
      '/admin/place/savecity/:cityId': 'saveCityById'
      '/admin/place/cityid/:cityId': 'getByCityId'
      '/admin/place/placeguid/:guid': 'getPlaceByCityId'

  methods:
    createReadStream: (opt) ->
      db.createReadStream opt

  handlers:
    saveCityById: saveCityById
    getByCityId: getByCityId
    getPlaceByCityId: getPlaceByCityId

  methods:
    db: -> db
    transforms: -> PlaceTransforms
    saveLevelCityToMongo: saveLevelCityToMongo

  init: (next) ->
    System.getSettings (err, settings) ->
      return next err if err
      citiesSetup = settings?.citiesSetup == true
      countriesSetup = settings?.countriesSetup == true

      return next() if citiesSetup and countriesSetup
      console.log "not set up #{citiesSetup}, #{countriesSetup}"
      console.log settings

      Setup.countries Place
      .then Setup.cities db, Place
      .done (result) ->
        console.log 'result', result
        settings.citiesSetup = true
        settings.countriesSetup = true
        System.updateSettings settings, (err) ->
          return next err if err
          next err
      , (err) ->
        console.log 'error', err
        console.error err.stack
        next err
