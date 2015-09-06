module.exports = (city, next) ->
  next null,
    guid: "cityid:#{city.cityId}"
    name: city.name
    region: city.region
    country: city.country
    specificity: 4
    location: city.location
    containedBy: city.countryId
    data: city
