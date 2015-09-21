_ = require 'lodash'
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
  postInit = ->
    statusFromLevel = ->
      Promise.promise (resolve, reject) ->
        db.get 'citiesSetup', (err, item) ->
          return reject err if err and err.type != 'NotFoundError' and err.status != 404
          resolve item?.status == true

    statusFromMongo = ->
      Promise.promise (resolve, reject) ->
        System.getSettings (err, settings) ->
          return reject err if err
          citiesSetup = settings?.citiesSetup == true
          countriesSetup = settings?.countriesSetup == true
          resolve citiesSetup and countriesSetup

    saveStatusToLevel = (data) ->
      Promise.promise (resolve, reject) ->
        db.put 'citiesSetup', data, (err, item) ->
          return reject err if err
          resolve()

    saveStatusToMongo = (newSettings) ->
      Promise.promise (resolve, reject) ->
        System.getSettings (err, settings) ->
          settings = _.merge settings, newSettings
          System.updateSettings settings, (err) ->
            return reject err if err
            resolve()

    Promise.all [
      statusFromLevel()
      statusFromMongo()
    ]
    .then (status) ->
      return 'already set up' if status[0] == true and status[1] == true
      # console.log "not set up #{citiesSetup}, #{countriesSetup}"
      # console.log settings

      Setup.countries Place
      .then Setup.cities db, Place
      .then (result) ->
        console.log 'result', result
        newSettings =
          citiesSetup: true
          countriesSetup: true
        Promise.all [
          saveStatusToLevel {status: true}
          saveStatusToMongo newSettings
        ]
      .then -> 'set up'
    .then (status) ->
      console.log 'kerplunk-place status', status

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

  handlers:
    saveCityById: saveCityById
    getByCityId: getByCityId
    getPlaceByCityId: getPlaceByCityId

  methods:
    db: -> db
    createReadStream: (opt) ->
      db.createReadStream opt
    transforms: -> PlaceTransforms
    saveLevelCityToMongo: saveLevelCityToMongo

  events:
    init:
      post: postInit
