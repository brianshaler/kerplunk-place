fs = require 'fs'
cities1000 = require 'cities1000'
csv = require 'csv-stream'
es = require 'event-stream'

#csvObjectToCity = require './transform/csvObjectToCity'

module.exports = (file = cities1000.file) ->
  csvOptions =
    delimiter: '\t'
    columns: cities1000.fields

  fs.createReadStream file
  .pipe csv.createStream csvOptions
  #.pipe es.map csvObjectToCity
