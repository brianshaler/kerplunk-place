countryCodeToPlace = require '../../../src/setup/transform/countryCodeToPlace'

describe 'setup/transform/countryCodeToPlace', ->
  it 'should turn a country code into a Place object', ->
    countryPlace = @fixture 'countryPlace.json'
    obj = countryCodeToPlace 'US'
    Should.deepEqual obj, countryPlace

  it 'should turn return null if country code not found', ->
    countryPlace = @fixture 'countryPlace.json'
    Should.equal null, countryCodeToPlace '404LOL'
