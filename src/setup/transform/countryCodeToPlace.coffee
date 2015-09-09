_ = require 'lodash'
countries = require 'world-countries'

module.exports = (countryCode) ->
  country = _.find countries, (obj) ->
    obj.cca2 == countryCode or obj.cca3 == countryCode

  return null unless country?

  return null if country.longitude == '' or country.latitude == ''
  return null unless country.latlng?.length == 2

  [latitude, longitude] = country.latlng

  guid: "country-#{countryCode}"
  name: country.name.common
  country: country.name.common
  specificity: 1
  location: [longitude, latitude]
  data: _.extend {countryCode: countryCode}, country
