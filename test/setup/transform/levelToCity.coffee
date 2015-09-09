levelToCity = require '../../../src/setup/transform/levelToCity'

describe 'setup/transform/levelToCity', ->
  it 'should turn a level array into a city object', ->
    cityArray = @fixture 'philly.level.array.json'
    cityObject = @fixture 'philly.level.object.json'
    obj = levelToCity cityArray
    Should.deepEqual obj, cityObject
