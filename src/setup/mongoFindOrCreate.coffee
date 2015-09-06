
# terribly inefficient way of doing this...
# will ponder+research better ways to stream -> mongo

module.exports = (Model, keyProp = '_id') ->
  (data, next) ->
    where = {}
    where[keyProp] = data[keyProp]
    Model.findOne where, (err, record) ->
      return next err if err
      return next null, 'existed' if record
      model = new Model data
      model.save (err) ->
        return next err if err
        next null, 'inserted'
