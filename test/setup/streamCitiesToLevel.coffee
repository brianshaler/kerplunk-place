streamCitiesToLevel = require '../../src/setup/streamCitiesToLevel'

describe 'setup/streamCitiesToLevel', ->
  before ->
    @cities = @fixture 'citiessample.json'

  it 'should transform x cities to x*2 level records', (done) ->
    stream = streamCitiesToLevel()

    outputs = []
    keys = {}

    stream
    .on 'data', (data) ->
      outputs.push data
      keys[data.key] = data.value
    .on 'end', =>
      outputs.length.should.not.equal 0
      outputs.length.should.equal @cities.length * 2
      phillyId = '4560349'
      philly = keys["cityid:#{phillyId}"]
      Should.exist philly
      philly[6].should.equal phillyId
      done()

    for city in @cities
      stream.write city
    stream.end()
