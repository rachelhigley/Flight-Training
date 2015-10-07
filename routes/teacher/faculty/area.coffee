express = require('express')
router  = express.Router()
models  = appRequire('models')

# add the area to the term and levels
router.post '/', (req, res, next) ->
  console.log req.body
  models.Course.find
    where:
      abbr: req.body.courseAbbr
  .then (course) ->
    req.body.CourseId = course.id

    models.Area.create req.body
    .then (area) ->
      for level in req.body['levels']
        area.addLevel level
      res.send area


module.exports = router