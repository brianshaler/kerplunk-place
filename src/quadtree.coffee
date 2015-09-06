split = (bbox) ->
  left = bbox[0][0]
  top = bbox[0][1]
  right = bbox[1][0]
  bottom = bbox[1][1]
  cx = bbox[0][0] + (bbox[1][0] - bbox[0][0]) / 2
  cy = bbox[0][1] + (bbox[1][1] - bbox[0][1]) / 2

  [
    [[left, top], [cx, cy]]
    [[cx, top], [right, cy]]
    [[left, cy], [cx, bottom]]
    [[cx, cy], [right, bottom]]
  ]

isPointWithin = (p, bbox) ->
  p[0] >= bbox[0][0] and p[0] < bbox[1][0] and p[1] >= bbox[0][1] and p[1] < bbox[1][1]

getQuadtree = (point, depth) ->
  bbox = [
    [-180, -90]
    [180, 90]
  ]
  quadtree = []
  for i in [0..depth] by 1
    return null if !bbox
    quads = split bbox
    index = quads.reduce (memo, bb, index) ->
      if isPointWithin point, bb
        index
      else
        memo
    , 0
    quadtree.push index
    bbox = quads[index]
  quadtree

module.exports = (point, depth) ->
  quadtree = getQuadtree point, depth

  key = ''
  for i in [0..depth] by 4
    index = quadtree[i] * 64
    index += (quadtree[i + 1] ? 0) * 16
    index += (quadtree[i + 2] ? 0) * 4
    index += quadtree[i + 3] ? 0
    key += String.fromCharCode index
  key
