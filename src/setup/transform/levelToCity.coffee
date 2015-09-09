module.exports = (value) ->
  guid: "cityid:#{value[0]}"
  name: value[1]
  asciiName: value[1]
  region: value[2]
  country: value[3]
  location: [value[4], value[5]]
  population: value[6]
  cityId: value[7]
  timezone: value[8]
  countryCode: value[9]
  countryId: value[10]
