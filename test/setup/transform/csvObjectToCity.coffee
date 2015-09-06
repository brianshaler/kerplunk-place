csvObjectToCity = require '../../../src/setup/transform/csvObjectToCity'

describe 'setup/transform/csvObjectToCity', ->
  it 'should turn a csv-formatted object into a level-formatted object', (done) ->
    cityCSV = @fixture 'philly.csv.json'
    cityLevel = @fixture 'philly.level.json'
    csvObjectToCity cityCSV, (err, obj) ->
      Should.not.exist err
      Should.exist obj.cityId
      obj.cityId.should.equal cityLevel.cityId
      obj.cityId.should.equal cityCSV.id
      done()
