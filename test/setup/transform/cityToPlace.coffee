cityToPlace = require '../../../src/setup/transform/cityToPlace'

describe 'setup/transform/cityToPlace', ->
  it 'should turn a city object into a Place object', ->
    cityObject = @fixture 'philly.level.object.json'
    result = null
    obj = cityToPlace cityObject, (err, place) ->
      Should.not.exist err
      result = place
    Should.deepEqual obj,
        guid: "cityid:#{cityObject.cityId}"
        name: cityObject.name
        region: cityObject.region
        country: cityObject.country
        specificity: 4
        location: cityObject.location
        containedBy: cityObject.countryId
        data: cityObject
