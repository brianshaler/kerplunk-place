es = require 'event-stream'

cityToKeyedRecords = require '../../../src/setup/transform/cityToKeyedRecords'

describe 'setup/transform/cityToKeyedRecords', ->
  it 'should turn each input item into several keyed items', ->
    cityObject = @fixture 'philly.level.object.json'

    stream = es.through()
    results = []

    stream.pipe cityToKeyedRecords()
    .on 'data', (data) ->
      results.push data

    stream.write cityObject
    results.length.should.equal 3
    results[0].key.should.equal "cityid:#{cityObject.cityId}"
    /^ll:/.test(results[1].key).should.equal true
    results[2].key.should.equal 'nm:' + cityObject.name.toLowerCase() + cityObject.cityId
