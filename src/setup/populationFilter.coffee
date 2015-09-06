es = require 'event-stream'

module.exports = (minPopulation) ->
  (city, next) ->
    # only pass through big cities
    return next() unless city.population > minPopulation
    next null, city
