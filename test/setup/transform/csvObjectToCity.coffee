csvObjectToCity = require '../../../src/setup/transform/csvObjectToCity'

describe 'setup/transform/csvObjectToCity', ->
  it 'should turn a csv-formatted object into a level-formatted object', ->
    cityCSV = @fixture 'philly.csv.json'
    cityLevel = @fixture 'philly.level.object.json'
    countryPlace = @fixture 'countryPlace.json'
    result = null
    csvObjectToCity([countryPlace]) cityCSV, (err, data) ->
      Should.not.exist err
      result = data
    Should.exist result
    result.cityId.should.equal cityLevel.cityId
    result.name.should.equal cityLevel.name
    result.country.should.equal cityLevel.country
    result.countryCode.should.equal cityLevel.countryCode
