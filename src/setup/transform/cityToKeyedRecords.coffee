es = require 'event-stream'

cityToLevel = require './cityToLevel'
quadtree = require '../../quadtree'

module.exports = ->
  es.through (city) ->
    name = city.asciiName
    unless name? and name.length > 0
      name = city.name

    val = cityToLevel city

    @emit 'data',
      key: "cityid:#{city.cityId}"
      value: val

    quad = quadtree city.location, 12

    @emit 'data',
      key: "ll:#{quad}#{city.cityId}"
      value: "cityid:#{city.cityId}"

    if name and name.length > 0
      # add uniqueness to the end
      @emit 'data',
        key: "nm:#{name.toLowerCase() + city.cityId}"
        value: val
