populationFilter = require '../../src/setup/populationFilter'

describe 'setup/populationFilter', ->
  it 'should return 2 large cities with 1,000,000', ->
    cities = @fixture 'citiessample.json'

    output = []
    filter = populationFilter 1000000

    for city in cities
      filter city, (err, obj) ->
        return done err if err
        output.push obj if obj

    output.length.should.equal 2

  it 'should return 5 cities with more than 10,000', ->
    cities = @fixture 'citiessample.json'

    output = []
    filter = populationFilter 10000

    for city in cities
      filter city, (err, obj) ->
        return done err if err
        output.push obj if obj

    output.length.should.equal 5
