es = require 'event-stream'

cityToLevel = require './cityToLevel'
quadtree = require '../../quadtree'

module.exports = ->
  es.through (city) ->
    key = city.asciiName
    unless key? and key.length > 0
      key = city.name

    # add uniqueness to the end
    val = cityToLevel city

    @emit 'data',
      key: "cityid:#{city.cityId}"
      value: val

    quad = quadtree city.location, 12
    
    @emit 'data',
      key: "ll:#{quad}"
      value: "cityid:#{city.cityId}"

    if key and key.length > 0
      key = key.toLowerCase() + city.cityId
      @emit 'data',
        key: key
        value: val
