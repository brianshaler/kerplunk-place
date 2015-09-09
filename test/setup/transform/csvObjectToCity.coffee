es = require 'event-stream'

csvObjectToCity = require '../../../src/setup/transform/csvObjectToCity'

describe 'setup/transform/csvObjectToCity', ->
  it 'should turn a csv-formatted object into a level-formatted object', ->
    cityCSV = @fixture 'philly.csv.json'
    cityLevel = @fixture 'philly.level.json'
    countryPlaces = @fixture 'countryPlaces.json'
    result = null
    map = csvObjectToCity countryPlaces
    map cityCSV, (err, data) ->
      Should.not.exist err
      result = data
    Should.exist result
    for k, v of cityLevel
      Should.exist result[k]
      result.cityId.should.equal cityLevel.cityId
      result.name.should.equal cityLevel.name
      result.country.should.equal cityLevel.country
      result.countryCode.should.equal cityLevel.countryCode
