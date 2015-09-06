module.exports = (countryPlaces) ->
  byCode = {}
  for place in countryPlaces
    byCode[place.data.countryCode] = place
  (data, callback) ->
    countryObject = byCode[data.country]

    obj =
      guid: "cityid:#{data.id}"
      cityId: data.id
      name: data.name
      asciiName: data.asciiname
      timezone: data.tz
      population: parseInt data.population
      countryCode: data.country
      country: countryObject?.data?.name?.common ? countryObject?.data?.name ? data.country
      countryId: countryObject?._id
    lat = parseFloat data.lat
    lon = parseFloat data.lon
    obj.location = [lon, lat]
    obj.region = ''
    obj.region = data.adminCode unless /[\d]+/.test data.adminCode
    #console.log JSON.stringify obj if count < 100 or obj.name == 'Phoenix'
    #count++
    callback null, obj
