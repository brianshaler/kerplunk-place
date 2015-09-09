es = require 'event-stream'

cityToLevel = require './cityToLevel'
quadtree = require '../../quadtree'

module.exports = ->
  es.through (city) ->
    key = city.asciiName
    unless key? and key.length > 0
      key = city.name

    val = cityToLevel city

    @emit 'data',
      key: "cityid:#{city.cityId}"
      value: val

    quad = quadtree city.location, 12

    @emit 'data',
      key: "ll:#{quad}#{city.cityId}"
      value: "cityid:#{city.cityId}"

    if key and key.length > 0
      # add uniqueness to the end
      key = key.toLowerCase() + city.cityId
      @emit 'data',
        key: key
        value: val
