cityToLevel = require '../../../src/setup/transform/cityToLevel'

describe 'setup/transform/cityToLevel', ->
  it 'should turn a city object into a level array', ->
    cityObject = @fixture 'philly.level.object.json'
    cityArray = @fixture 'philly.level.array.json'
    arr = cityToLevel cityObject
    Should.deepEqual arr, cityArray
