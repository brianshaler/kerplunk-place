_ = require 'lodash'
countries = require 'world-countries'

module.exports = (countryCode) ->
  country = _.find countries, (obj) ->
    obj.cca2 == countryCode or obj.cca3 == countryCode

  return null unless country?

  return null if country.longitude == '' or country.latitude == ''
  return null unless country.latlng?.length == 2

  ###
  # parsing iso-countries
  # longitude = country.longitude
  #   .replace /^[^\d]+/, ''
  #   .replace /[^\d]+$/, ''
  #   .replace ' ', '.'
  # longitude = parseFloat longitude
  # longitude *= -1 if /w$/i.test country.longitude
  # latitude = country.latitude
  #   .replace /^[^\d]+/, ''
  #   .replace /[^\d]+$/, ''
  #   .replace ' ', '.'
  # latitude = parseFloat latitude
  # latitude *= -1 if /s$/i.test country.latitude
  ###

  [latitude, longitude] = country.latlng

  guid: "country-#{countryCode}"
  name: country.name.common
  country: country.name.common
  specificity: 1
  location: [longitude, latitude]
  data: _.extend {countryCode: countryCode}, country
