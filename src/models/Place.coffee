###
# Place schema
###

module.exports = (mongoose) ->
  Schema = mongoose.Schema
  ObjectId = Schema.ObjectId

  PlaceSchema = new Schema
    guid:
      type: String
      required: true
      index:
        unique: true
    name:
      required: true
      index: true
      type: String
    specificity:
      type: Number
      default: -> 0
    # 0: Earth? Continent?
    # 1: Country
    # 2: Region/State/Province
    # 3: County
    # 4: City
    # 5: Neighborhood
    # 6: Venue
    containedBy:
      type: ObjectId
    address1:
      type: String
    address2:
      type: String
    city:
      type: String
    region:
      type: String
    country:
      type: String
    postalCode:
      type: String
    location:
      type: [Number]
      index: '2dsphere'
    data:
      type: Object
    updatedAt:
      type: Date
      default: Date.now
    createdAt:
      type: Date
      default: Date.now

  mongoose.model 'Place', PlaceSchema
