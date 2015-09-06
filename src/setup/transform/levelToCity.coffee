module.exports = (value) ->
  guid: "cityid:#{value[0]}"
  name: value[0]
  asciiName: value[0]
  region: value[1]
  country: value[2]
  location: [value[3], value[4]]
  population: value[5]
  cityId: value[6]
  timezone: value[7]
  countryCode: value[8]
  countryId: value[9]
