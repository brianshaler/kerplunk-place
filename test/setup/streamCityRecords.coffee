path = require 'path'
streamCityRecords = require '../../src/setup/streamCityRecords'

describe 'setup/streamCityRecords', ->
  it 'should stream a few items', (done) ->
    csvPath = @fixturePath 'citiessample.txt'
    cities = []
    cities.length.should.equal 0
    streamCityRecords csvPath
    .on 'data', (city) ->
      cities.push city
    .on 'end', ->
      cities.length.should.equal 12
      # generates citiessample.json
      #console.log JSON.stringify cities, null, 2
      done()
